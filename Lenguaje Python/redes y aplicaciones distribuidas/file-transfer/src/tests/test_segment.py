from segments.segment import UDPSegment
import zlib

def test_init():
    source_port = 1234
    destination_port = 5678
    data = "This is a test".encode('utf-8')
    udp_segment = UDPSegment(source_port, destination_port, data, total_segments=1)

    expected_checksum = zlib.crc32(data)

    assert udp_segment.source_port == source_port
    assert udp_segment.destination_port == destination_port
    assert udp_segment.length == 12 + len(data)
    assert udp_segment.checksum == expected_checksum
    assert udp_segment.sequence_number == 0
    assert udp_segment.data_slice == data

def test_calc_length():
    source_port = 1234
    destination_port = 5678
    data = "This is a test".encode('utf-8')
    udp_segment = UDPSegment(source_port, destination_port, data, total_segments=1)
    assert udp_segment.calc_length() == 12 + len(data)