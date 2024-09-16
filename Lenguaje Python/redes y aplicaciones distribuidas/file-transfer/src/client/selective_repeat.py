import os
import pickle
from collections import OrderedDict, deque
from client.udp_protocol import UDPProtocol
from feedback.ack import AckMessage
from feedback.messages import DownloadMessage, UploadMessage
from feedback.response import Response
from global_consts.constants import SERVER_MAX_RETRY_TIMES, SERVER_RECHECK_TIME, SR_SERVER_TIMEOUT_TIME, SR_WINDOW_SIZE, SR_WINDOW_SIZE
from segments.segment import UDPSegment
from segments.segment_factory import UDPSegmentFactory
from client.selective_repeat_window import Window, WindowElement
from server.server import FileStorageData, StorageBufferData

# Network simulation (Delayed ACK or Lost ACK)
# 1. packet loss --> 10%
# 2. network delay --> time.sleep(0.1) --> 10% of the time

class SelectiveRepeatUploader(UDPProtocol):
    """This class contains the logic for the Selective Repeat upload client.
    Args:
        UDPProtocol (_type_): _description_
    """

    def __init__(self, host, port, file, socket, file_source, file_name) -> None:
        super().__init__(host, port, file, socket)
        self.file_source = file_source
        self.file_name = file_name
        self.acked_segments = OrderedDict()  # Dict<seq_number, bool> --> True if ACKed, False if not ACKed
        self.sliding_window = Window(SR_WINDOW_SIZE)

    def handle(self) -> Response:
        """This function is public. It sends the file through the socket."""
        with open(self.file, "rb") as file:
            data = file.read()
            segment_factory = UDPSegmentFactory(self.port, self.port, data)
            self.__initialize_acked_segments(segment_factory)
            self.__initialize_sliding_window(segment_factory)


            print("sliding window:", self.sliding_window.elements)

            self.__send_first_segment_burst() 

            print("segments sent")
            
            # While not last element is ACKed
            while not self.acked_segments[segment_factory.get_total_data_slices() - 1]:

                if self.__resend_timedout_segments() == Response.Error:
                    print(">Error: max retries exceeded for segment.")
                    return Response.Error

                try: 
                    self.socket.settimeout(SERVER_RECHECK_TIME)
                    ack, _ = self.socket.recvfrom(1024)
                    
                except TimeoutError:
                    print("Rechecking timeouts...")
                    continue
                
                ack_msg: AckMessage = pickle.loads(ack)
                print("ack received:", ack_msg.sequence_number)

                if ack_msg.has_error():
                    print(f"Error: {ack_msg.error_description}")
                    return Response.Error
                
                if self.acked_segments[ack_msg.sequence_number]:
                    print("Segment already ACKed. Ignoring ACK.")
                    continue

                new_elems = self.__mark_as_received(ack_msg.sequence_number)
                if new_elems:
                    if self.__send_segments_burst(new_elems) == Response.Error:
                        print(">Error: max retries exceeded for segment.")
                        return Response.Error

            return Response.Ok
        
    def __initialize_acked_segments(self, segment_factory: UDPSegmentFactory):
        for i in range(segment_factory.get_total_data_slices()):
            self.acked_segments[i] = False

    def __initialize_sliding_window(self, segment_factory: UDPSegmentFactory):
        self.sliding_window.set_segment_factory(segment_factory)

    def __send_first_segment_burst(self):
        # No need to check Response, first burst is always Ok
        self.__send_segments_burst(self.sliding_window.elements)

    def __send_segments_burst(self, timedout_segments: [WindowElement]) -> Response:
        result = Response.Ok
        print("sending: ", timedout_segments)
        for window_elem in timedout_segments:
            print("sending segment:", window_elem.segment.sequence_number)
            msg = UploadMessage(self.file_source, self.file_name, window_elem.segment)
            self.socket.sendto(pickle.dumps(
                msg), (self.host, int(self.port)))
            print("segment sent")
            if self.sliding_window.update_segment(window_elem.segment.sequence_number) == Response.Error:
                return Response.Error
            
        return result

    def __mark_as_received(self, sequence_number) -> [WindowElement]:
        self.acked_segments[sequence_number] = True
        self.sliding_window.ack_segment(sequence_number)
        return self.__update_window()

    def __update_window(self):
        # Sort by sequence number
        print("updating window")
        window_elems = self.sliding_window.get_sorted_elements(sort_by_seq_num=True)
        new_elems: [WindowElement] = []
        for we in window_elems:
            segment = we.segment
            print("checking if segment is acked:", segment.sequence_number)
            if self.acked_segments[segment.sequence_number]:
                print("is acked")
                new_elems += self.sliding_window.remove_segment(segment.sequence_number)
            else:
                print("not acked")
                break
        return new_elems

    def __resend_timedout_segments(self) -> Response:
        timedout_segments = self.sliding_window.get_timedout_segment()
        if timedout_segments:
            print("Resend timedout: ", [x.segment.sequence_number for x in timedout_segments] )
            res = self.__send_segments_burst(timedout_segments)
            return res
        return Response.Ok

####### DOWNLOAD #######

class SelectiveRepeatDownloader(UDPProtocol):
    """This class contains the logic for the Selective Repeat download client.
    Args:
        UDPProtocol (_type_): _description_
    """

    def __init__(self, host, port, file, socket, file_destination, file_name) -> None:
        super().__init__(host, port, file, socket)
        self.file_destination = file_destination if file_destination else "~/Downloads"
        self.file_name = file_name
        self.storage_buffer = [] # List<StorageBufferData>
        self.acked_segments = OrderedDict()  # Dict<seq_number, bool> --> True if ACKed, False if not ACKed
        self.data = {}  # {path+file_name: FileStorageData}

    def handle(self):
        """This function downloads the file through the socket."""
        msg = DownloadMessage(self.file)
        self.socket.sendto(pickle.dumps(msg), (self.host, int(self.port)))

        max_retries = 0
        segment_data = None
        while True:
            print()
            try:
                self.socket.settimeout(SR_SERVER_TIMEOUT_TIME) 
                segment_received, address = self.socket.recvfrom(1700)
            except TimeoutError:
                # Server only times out here when waiting for segment. So it resends ACK.
                # For downloads, server handles timesout in find_file
                if segment_data:
                    if max_retries > SERVER_MAX_RETRY_TIMES:
                        print("Max retries exceeded. Client closing client conection.")
                        break
                    print("Client timed out waiting for segments.")
                    print("Sending ACK again for", self.get_last_seq_number())
                    ack_msg = AckMessage(self.get_last_seq_number())
                    self.socket.sendto(pickle.dumps(ack_msg), address)
                    max_retries += 1
                continue
            
            segment_data: UDPSegment = pickle.loads(segment_received)
            print("Message length:", len(segment_received))

            if segment_data.has_error():
                print(f"Error: {segment_data.error_description}")
                return Response.Error

            returned_seq_num, download_complete = self.storage_segment(segment_data)
            ack_msg = AckMessage(returned_seq_num)
            print("Sending ACK:", ack_msg.sequence_number, "upload complete:", download_complete)
            self.socket.sendto(pickle.dumps(ack_msg), address)
            
            if download_complete:
                print("> Download finished.")
                break

    def full_path(self):
        return self.file_destination + "/" + self.file_name

    def storage_segment(self, segment: UDPSegment) -> Response:        
        try:
            last_seq_num = self.get_last_seq_number()
            base = last_seq_num + 1 # base of window, lowest seq number not yet received
            print("download: segment.seq_num", segment.sequence_number)
            print("download: last seq_num:", last_seq_num)
            print("download: base:", base)

            seqs_received = set()

            if not segment.checksum_is_correct():
                print("checksum is not correct")
                return (last_seq_num, last_seq_num == segment.total_segments -1)
            
            # Segment is in prev window, so it's already stored. Just ACK it
            if self.data_is_in_prev_window(segment.sequence_number):
                print("segment is previous window")
                return (segment.sequence_number, last_seq_num == segment.total_segments -1) # ACK the segment, but there's nothing to do with it (it's already stored)
            
            # Segment is in window, and it's not base, so the window does not move. But we still Ack it
            if segment.sequence_number != base and self.data_is_in_window(segment.sequence_number):
                print("segment is in window, but is not base")
                if segment.sequence_number in seqs_received:
                    return (segment.sequence_number, last_seq_num == segment.total_segments -1)
                
                self.storage_buffer.append(StorageBufferData(segment, True))
                seqs_received.add(segment.sequence_number)

                return (segment.sequence_number, last_seq_num == segment.total_segments -1) # ACK the segment, but don't write it to file yet
            
            # Segment is in window, and it's base, so the window moves. We also store all the segments we can from base
            elif segment.sequence_number == base:
                print("segment is base")
                self.storage_buffer.append(StorageBufferData(segment, acked=True))
                
                buffer_elems: [WindowElement] = self.storage_buffer.copy()
                buffer_elems.sort(key=lambda x: x.segment.sequence_number)
                print("storage buffer:", [x.segment.sequence_number for x in self.storage_buffer])

                seqs_received.add(segment.sequence_number)
                segments_to_store = b''
                prev_seq_num = buffer_elems[0].segment.sequence_number - 1
                for sf_data in buffer_elems:
                    seq_num = sf_data.segment.sequence_number
                    if prev_seq_num + 1 != seq_num:
                        break
                        
                    print("storing element:", seq_num)
                    self.storage_buffer.remove(sf_data)
                    segments_to_store += sf_data.segment.data_slice
                    prev_seq_num += 1
                if segments_to_store != b'':
                    print("storing segments with seq_num:", prev_seq_num)
                    self.storage_data(segments_to_store, prev_seq_num)
            else:
                print("segment is not in window")
                return (last_seq_num, last_seq_num == segment.total_segments -1)

            return (segment.sequence_number, segment.sequence_number == segment.total_segments -1)
        
        except Exception as exception:
            print(f"Error during file download: {str(exception)}")
            return (self.get_last_seq_number(), False)
        
    def data_is_in_prev_window(self, seq_number):
        base = self.get_last_seq_number() + 1
        return 0 < seq_number < base  
    
    def data_is_in_window(self, seq_number):
        base = self.get_last_seq_number() + 1
        n = SR_WINDOW_SIZE
        return base <= seq_number < base + n

    def get_last_seq_number(self):
        file_path = self.full_path()
        sequence_info = self.data.get(file_path)
        if not sequence_info:
            self.data[file_path] = FileStorageData.new()
        file_storage_data: FileStorageData = self.data[file_path]
        return file_storage_data.seq_number

    def storage_data(self, data, seq_num):
        if not os.path.exists(self.file_destination):
            os.makedirs(self.file_destination)

        complete_path = os.path.join(self.file_destination, self.file_name)
        with open(complete_path, 'ab') as file:
            file.write(data)
        
        file_path = self.full_path()
        self.data[file_path] = FileStorageData(seq_num, complete_path, False)

    def file_exists(self):
        return os.path.exists(self.full_path())