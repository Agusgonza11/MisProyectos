import struct
import zlib


class UDPSegment:
    """UDPDataSegment stores the segment's header and data in a sendable format"""

    # UDP header size in bytes (4 items * 2 bytes each + 4 bytes for checksum)
    HEADER_SIZE = 12

    def __init__(self, source_port, destination_port, data, total_segments, length=None, checksum=None, sequence_number=0, is_last_segment=False):
        # Data
        self.data_slice = data
        # Header
        self.source_port = source_port
        self.destination_port = destination_port
        self.length = length if length != None else self.calc_length()
        self.checksum = checksum if checksum != None else self.calc_checksum(
            data)
        self.sequence_number = sequence_number
        self.is_last_segment = is_last_segment
        self.total_segments = total_segments
        self.error_description = None

    @classmethod
    def error(self, description):
        seg = UDPSegment(-1, -1, b"", 0, -1, -1, -1, False)
        seg.error_description = description
        return seg

    def has_error(self):
        return self.sequence_number < 0

    def calc_length(self):
        """Returns the length of the UDP header, which is a fixed size, plus the length of the data"""
        return UDPSegment.HEADER_SIZE + len(self.data_slice)

    def checksum_is_correct(self):
        """Returns True if the checksum is correct, False otherwise."""
        return UDPSegment.calc_checksum(self.data_slice) == self.checksum

    @staticmethod
    def calc_checksum(data):
        checksum = zlib.crc32(data)
        return checksum

    # Additional Methods
    def __repr__(self):
        return f"Source Port: {self.source_port}\n"+f"Destination Port: {self.destination_port}\n"+f"Length: {self.length}\n"+f"Checksum: {self.checksum}\n"+f"Sequence Number: {self.sequence_number}\n"+f"Is_last_segment: {self.is_last_segment}\n"

    def __eq__(self, obj):
        return self.source_port == obj.source_port and self.destination_port == obj.destination_port and self.length == obj.length and self.checksum == obj.checksum and self.sequence_number == obj.sequence_number and self.data_slice == obj.data_slice
