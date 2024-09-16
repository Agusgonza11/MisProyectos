from segments.segment_factory import UDPSegmentFactory
from segments.data_handler import DataHandler

def test_init():
    source_port = 1234
    destination_port = 5678
    data = "This is a test"
    udp_segment_factory = UDPSegmentFactory(source_port, destination_port, data)
    assert udp_segment_factory.source_port == source_port
    assert udp_segment_factory.destination_port == destination_port
    assert udp_segment_factory.data_handler.data == DataHandler(data).data

def test_get_multiplexed_data_segment():
    source_port = 1234
    destination_port = 5678
    data = "This is a test".encode('utf-8')
    udp_segment_factory = UDPSegmentFactory(source_port, destination_port, data)
    assert udp_segment_factory.get_multiplexed_data_segment() is not None