import os
import pickle
from client.udp_protocol import UDPProtocol

from segments.segment_factory import UDPSegmentFactory
from feedback.ack import AckMessage
from feedback.messages import UploadMessage, DownloadMessage
from segments.segment import UDPSegment
from global_consts.constants import SW_CLIENT_TIMEOUT_TIME, MAX_MESSAGE_SIZE
from feedback.response import Response

class StopAndWaitUploader(UDPProtocol):
    """This class contains the logic for the upload client.

    Args:
        ClientHandler (_type_): _description_
    """

    def __init__(self, host, port, file, socket, file_source, file_name) -> None:
        super().__init__(host, port, file, socket)
        self.file_source = file_source
        self.file_name = file_name

    def handle(self) -> Response:
        """This function sends the file through the socket."""
        with open(self.file, "rb") as file:
            data = file.read()
            segment_factory = UDPSegmentFactory(self.port, self.port, data)

            # Gets data and sends it
            segment = segment_factory.get_multiplexed_data_segment()
            while segment:
                print(f"Segment from the client: {segment}")
                msg = UploadMessage(self.file_source, self.file_name, segment)

                self.socket.sendto(pickle.dumps(
                    msg), (self.host, int(self.port)))

                try:
                    self.socket.settimeout(SW_CLIENT_TIMEOUT_TIME)
                    ack, _ = self.socket.recvfrom(MAX_MESSAGE_SIZE)
                except TimeoutError:
                    print(
                        "Client timed out while waiting for ACK. Sending segment again.")
                    continue

                ack_msg: AckMessage = pickle.loads(ack)
                print(f"\nack.seq_num received: {ack_msg.sequence_number}")

                if ack_msg.sequence_number < 0 and segment.sequence_number + 1 == segment_factory.get_total_data_slices():
                    print("> Upload finished.")
                    break

                if ack_msg.has_error():
                    print(f"Error: {ack_msg.error_description}")
                    return Response.Error

                if ack_msg.sequence_number >= segment.sequence_number:
                    segment = segment_factory.get_multiplexed_data_segment(
                        recv_seq_num=ack_msg.sequence_number)
                else:
                    print(
                        "Error: NAK Message from server, a segment was lost. Sending segment again.")

        print("No more segments to send.")
        return Response.Ok

class StopAndWaitDownloader(UDPProtocol):
    """This class contains the logic for the download client.
    Args:
        UDPProtocol (_type_): _description_
    """

    def __init__(self, host, port, file, socket, file_destination, file_name) -> None:
        super().__init__(host, port, file, socket)
        self.file_destination = file_destination if file_destination else "~/Downloads"
        self.file_name = file_name
        self.file_path = self.file_destination + "/" + self.file_name
        self.elems_received = 0

    def handle(self) -> Response:
        """This function downloads the file through the socket."""
        msg = DownloadMessage(self.file)
        self.socket.sendto(pickle.dumps(msg), (self.host, int(self.port)))

        segment_data = None
        while True:
            try:
                self.socket.settimeout(SW_CLIENT_TIMEOUT_TIME)
                segment_received, address = self.socket.recvfrom(1500)
            except TimeoutError:
                print("Client timed out while receiving file. Sending ACK again.")
                if segment_data:
                    ack_msg = AckMessage(segment_data.sequence_number)
                    self.socket.sendto(pickle.dumps(ack_msg), (self.host, int(self.port)))
                continue

            segment_data: UDPSegment = pickle.loads(segment_received)

            if not segment_data:
                print("> Download finished.")
                break

            print(f"\Segment received: {segment_data}")
            if self.elems_received == segment_data.sequence_number:
                print("storing: ", segment_data.sequence_number)
                self.storage_segment(segment_data)
                ack_msg = AckMessage(segment_data.sequence_number)
            else:
                ack_msg = AckMessage(self.elems_received - 1)

            print("Sending ack", ack_msg.sequence_number)
            self.socket.sendto(pickle.dumps(ack_msg), address)

            if segment_data.is_last_segment and segment_data.sequence_number + 1 == self.elems_received:
                break

        return Response.Ok

    def storage_segment(self, segment: UDPSegment):
        self.elems_received += 1
        if not os.path.exists(self.file_destination):
            os.makedirs(self.file_destination)
        complete_path = os.path.join(self.file_destination, self.file_name)
        with open(complete_path, 'ab') as file:
            file.write(segment.data_slice)

    def file_exists(self):
        return os.path.exists(self.file_path)