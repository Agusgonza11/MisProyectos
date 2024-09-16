from collections import OrderedDict
import os
import pickle
import socket
from feedback.ack import AckMessage

from feedback.response import Response
from feedback.messages import DownloadMessage, Message
from segments.segment import UDPSegment
from segments.segment_factory import UDPSegmentFactory
from global_consts.constants import MAX_TRIES_EXCEEDED, SERVER_RECHECK_TIME, SR_WINDOW_SIZE, SW_SERVER_TIMEOUT_TIME, SR_SERVER_TIMEOUT_TIME, INDEX_STORAGE_PATH, INDEX_STORAGE_FILE_PATH, MAX_MESSAGE_SIZE
from client.selective_repeat_window import Window, WindowElement

class FileStorageData:
    def __init__(self, seq_number, full_path, completed=False):
        self.seq_number = seq_number
        self.full_path = full_path
        self.completed = completed

    @classmethod
    def new(cls):
        return cls(-1, "")

    def __repr__(self) -> str:
        return f"(seq_number: {self.seq_number}, full_path: {self.full_path})"

class StorageBufferData:
    def __init__(self, segment: UDPSegment, acked=False):
        self.segment = segment
        self.acked = acked

    def __repr__(self) -> str:
        return f"(segment: {self.segment}, acked: {self.acked})"

class Server:
    """This class contains the logic for the server.
    """

    def __init__(self, host, port, storage, window_size=1) -> None:
        self.host = host
        self.port = port
        self.data = {}  # {path+file_name: FileStorageData}. This is used for upload
        self.storage = storage if storage else "server"
        self.acked_segments = OrderedDict()  # Dict<seq_number, bool> --> True if ACKed, False if not ACKed
        self.window_size = window_size
        self.storage_buffer = [] # List<StorageBufferData>
        self.sliding_window = Window(SR_WINDOW_SIZE)
        self.initialize_storage()
        self.initialize_availables()
        self.segments_to_send = {} # Dict<address, (segment_factory, last_segment_sent)>. This is used for download

    def initialize_storage(self):
        if not os.path.exists(self.storage):
            os.mkdir(self.storage)

    def upload(self, data: Message) -> (int, bool):
        try:
            segment: UDPSegment = data.message
            last_seq_num = self.get_last_seq_number_for_upload(data.full_path())
            base = last_seq_num + 1 # base of window, lowest seq number not yet received
            print("upload: segment.seq_num", segment.sequence_number)
            print("upload: last seq_num:", last_seq_num)
            print("upload: base:", base)

            seqs_received = set()

            if not segment.checksum_is_correct():
                print("checksum is not correct")
                return (last_seq_num, last_seq_num == segment.total_segments -1)
            
            # Segment is in prev window, so it's already stored. Just ACK it
            if self.data_is_in_prev_window(data):
                print("segment is previous window")
                return (segment.sequence_number, last_seq_num == segment.total_segments -1) # ACK the segment, but there's nothing to do with it (it's already stored)
            
            # Segment is in window, and it's not base, so the window does not move. But we still Ack it
            if segment.sequence_number != base and self.data_is_in_window(data):
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
                    # self.storage_data(data.path, data.name, sf_data.segment)
                    prev_seq_num += 1
                if segments_to_store != b'':
                    self.storage_data(data.path, data.name, segments_to_store, prev_seq_num)
            else:
                print("segment is not in window")

            return (segment.sequence_number, segment.sequence_number == segment.total_segments -1)
        
        except Exception as exception:
            print(f"Error during file upload: {str(exception)}")
            return (self.get_last_seq_number_for_upload(data.name), False)

    def mark_as_finished(self, data: Message) -> int:
        file_fullpath = data.path + "/" + data.name
        storage_path = self.storage + "/" + INDEX_STORAGE_PATH

        if not os.path.exists(storage_path):
            os.makedirs(storage_path)

        complete_path = os.path.join(storage_path, INDEX_STORAGE_FILE_PATH)

        with open(complete_path, 'a') as file:
            segment: UDPSegment = data.message
            surviving_data = file_fullpath + ":" + str(segment.sequence_number)
            file.write(surviving_data + "\n")
        self.data[file_fullpath].completed = True
        print("File marked as finished:", file_fullpath)

    def initialize_availables(self):
        storage_path = self.storage + "/" + INDEX_STORAGE_PATH
        complete_path = os.path.join(storage_path, INDEX_STORAGE_FILE_PATH)
        if os.path.exists(complete_path):
            with open(complete_path, 'r') as file:
                for line in file:
                    file_path, max_seq_number = line.strip().split(":")
                    max_seq_number = int(max_seq_number)
                    full_path = os.path.join(self.storage, file_path)
                    self.data[file_path] = FileStorageData(
                        max_seq_number, full_path, True)

        print("Data Initialized:", self.data)

    def file_is_available(self, file_path):
        print("file path:", file_path)
        storage_data = self.data.get(file_path)
        return storage_data != None and storage_data.completed

    def data_is_in_window(self, data: Message):
        base = self.get_last_seq_number_for_upload(data.full_path()) + 1
        n = self.window_size
        seq_num = data.message.sequence_number
        return base <= seq_num < base + n

    def data_is_in_prev_window(self, data: Message):
        base = self.get_last_seq_number_for_upload(data.full_path()) + 1
        seq_num = data.message.sequence_number
        return seq_num < base  

    def get_last_seq_number_for_upload(self, file_path):
        print("fullpath:", file_path)
        sequence_info = self.data.get(file_path)
        print("sequence info:", sequence_info)
        if not sequence_info:
            self.data[file_path] = FileStorageData.new()
        file_storage_data: FileStorageData = self.data[file_path]
        print("seq number:", file_storage_data.seq_number)
        return file_storage_data.seq_number
    
    def get_last_seq_number_for_download(self, address):
        segmentFactory = self.segments_to_send[address][0]
        segment = self.segments_to_send[address][1]
        return segment.sequence_number

    def storage_data(self, path, name, data, seq_num):
        actual_path = self.storage + "/" + path
        if not os.path.exists(actual_path):
            os.makedirs(actual_path)

        complete_path = os.path.join(actual_path, name)
        with open(complete_path, 'ab') as file:
            print("writing segment:", seq_num)
            file.write(data)
        
        file_path = path + "/" + name
        self.data[file_path] = FileStorageData(
            seq_num, complete_path, False)
        
    def open_segments(self, data: DownloadMessage, socket: socket, address) -> Response:
        if self.window_size > 1:
            print("\nSending file with Selective Repeat...")
            return self.open_segments_sr(data, socket, address)
        else:
            print("\nSending file with Stop and Wait...")
            self.open_segments_sw(data, socket, address)
            return Response.Ok
        
    def confirm_ack(self, ack_msg: AckMessage, socket: socket, address) -> Response:
        if self.window_size > 1:
            print("\nSending file with Selective Repeat...")
            return self.confirm_ack_sr(ack_msg, socket, address)
        else:
            print("\nSending file with Stop and Wait...")
            self.confirm_ack_sw(ack_msg, socket, address)
            return Response.Ok

    #### Selective Repeat ####
   
    def send_file_selective_repeat(self, data: DownloadMessage, socket: socket, address) -> Response:
        self.sr_socket = socket
        
        with open(self.storage + "/" + data.file_path, "rb") as file:
            data = file.read()
            segment_factory = UDPSegmentFactory(self.port, self.port, data)
            self.__initialize_acked_segments(segment_factory)
            self.__initialize_sliding_window(segment_factory)

            self.__send_first_segment_burst(address) 
            print("First segments sent")
            
            # While not last element is ACKed
            while not self.acked_segments[segment_factory.get_total_data_slices() - 1]:
                print("sending segments...")

                if self.__resend_timedout_segments(address) == Response.Error:
                    print(">Error: max retries exceeded for segment.")
                    self.sr_socket.sendto(pickle.dumps(UDPSegment.error(MAX_TRIES_EXCEEDED)), address)
                    return Response.Error

                try: 
                    self.sr_socket.settimeout(SERVER_RECHECK_TIME)
                    ack, _ = self.sr_socket.recvfrom(1024)
                    
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
                    if self.__send_segments_burst(new_elems, address) == Response.Error:
                        print(">Error: max retries exceeded for segment.")
                        return Response.Error

            print("No more segments to send")
            return Response.Ok

    def __initialize_acked_segments(self, segment_factory: UDPSegmentFactory):
        for i in range(segment_factory.get_total_data_slices()):
            self.acked_segments[i] = False

    def __initialize_sliding_window(self, segment_factory: UDPSegmentFactory):
        self.sliding_window.set_segment_factory(segment_factory)

    def __send_first_segment_burst(self, address):
        # No need to check Response, first burst is always Ok
        self.__send_segments_burst(self.sliding_window.elements, address)
    
    def __resend_timedout_segments(self, address) -> Response:
        timedout_segments = self.sliding_window.get_timedout_segment()
        if timedout_segments:
            print("Resend timedout: ", [x.segment.sequence_number for x in timedout_segments] )
            res = self.__send_segments_burst(timedout_segments, address)
            return res
        return Response.Ok
    
    def __send_segments_burst(self, timedout_segments: [WindowElement], address) -> Response:
        result = Response.Ok
        print("sending segment: ", timedout_segments)
        for window_elem in timedout_segments:
            print("sending segment:", window_elem.segment.sequence_number)
            segment = window_elem.segment
            self.sr_socket.sendto(pickle.dumps(segment), address)
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
    
            
    def confirm_ack_sw(self, ack_msg, socket, address):
        segment_factory: UDPSegmentFactory = self.segments_to_send[address][0]
        segment = self.segments_to_send[address][1]
        print("confirming ack for address:", address)
        print(f"\nACK seq_num received: {ack_msg.sequence_number}, last segment sent: {segment.sequence_number}")
        
        if ack_msg and ack_msg.sequence_number == segment.sequence_number:
            print("ACK is correct for the last segment sent")
            next_seq_num = segment.sequence_number + 1
            segment = segment_factory.get_multiplexed_data_segment(
            recv_seq_num=next_seq_num)
            if not segment:
                print("no more segments!")
                return
            self.segments_to_send[address] = (segment_factory, segment)
        else:
            print("Segment was lost while sending file from server. Sending segment again.")
        print("sending new segment:", segment.sequence_number)
        socket.sendto(pickle.dumps(segment), address)


    def confirm_ack_sr(self, ack_msg, socket, address) -> Response:
        if ack_msg.has_error():
            print(f"Error: {ack_msg.error_description}")
            return Response.Error

        new_elems = self.__mark_as_received(ack_msg.sequence_number)
        if new_elems:
            if self.__send_segments_burst(new_elems, address) == Response.Error:
                print(">Error: max retries exceeded for segment.")
                return Response.Error
    
        if self.__resend_timedout_segments(address) == Response.Error:
            print(">Error: max retries exceeded for segment.")
            self.sr_socket.sendto(pickle.dumps(UDPSegment.error(MAX_TRIES_EXCEEDED)), address)
            return Response.Error

        return Response.Ok


    def open_segments_sw(self, data: DownloadMessage, socket: socket, address):
        file_storage_data: FileStorageData = self.data[data.file_path]
        with open(file_storage_data.full_path, "rb") as file:
            data = file.read()
            segment_factory = UDPSegmentFactory(self.port, self.port, data)
            segment = segment_factory.get_multiplexed_data_segment()
            socket.sendto(pickle.dumps(segment), address)
            print("saving segment to send", segment.sequence_number)
            self.segments_to_send[address] = (segment_factory, segment)

    def open_segments_sr(self, data: DownloadMessage, socket: socket, address) -> Response:
        self.sr_socket = socket
        with open(self.storage + "/" + data.file_path, "rb") as file:
            data = file.read()
            segment_factory = UDPSegmentFactory(self.port, self.port, data)
            self.__initialize_acked_segments(segment_factory)
            self.__initialize_sliding_window(segment_factory)

            self.__send_first_segment_burst(address) 
            print("First segments sent")
            if self.__resend_timedout_segments(address) == Response.Error:
                print(">Error: max retries exceeded for segment.")
                self.sr_socket.sendto(pickle.dumps(UDPSegment.error(MAX_TRIES_EXCEEDED)), address)
                return Response.Error
        return Response.Ok

