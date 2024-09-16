# Struct allows to convert between Python data types and packed binary data that can be used for tasks like reading and writing binary files, working with network protocols, or handling low-level binary data formats.
from segments.data_handler import DataHandler
from segments.segment import UDPSegment


class UDPSegmentFactory:
    """Stores the segment's source, destination port and data, and provides data segments with sequence numbers"""

    def __init__(self, source_port, destination_port, data):
        # FIXME do we need a source_port?
        self.source_port = source_port
        self.destination_port = destination_port
        self.data_handler = DataHandler(data)

    def get_multiplexed_data_segment(self, recv_seq_num=None) -> UDPSegment:
        """Creates the UDP segment, converting Python data to binary.
        Returns the segment in binary format.
        If all data has been sent, returns None."""
        data_slice, seq_number = self.data_handler.get_data_slice(
            recv_seq_num=recv_seq_num)
        if not data_slice:
            return None

        segment = UDPSegment(self.source_port, self.destination_port, data_slice,
                             sequence_number=seq_number, is_last_segment=self.data_handler.is_last_slice(), total_segments=self.data_handler.get_total_data_slices())

        return segment

    def get_total_data_slices(self):
        return self.data_handler.get_total_data_slices()
