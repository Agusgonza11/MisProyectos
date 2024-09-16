from segments.data_handler import DataHandler

def test_init():
    data = "This is a test"
    data_handler = DataHandler(data)
    assert data_handler.sequence_number == 0
    assert data_handler.data == data
    assert data_handler.data_slices == ["This is a test"]
    assert data_handler.total_data_slices == 1

def test_slice_small_data():
    data = "This is a test"
    data_handler = DataHandler(data)
    assert data_handler._DataHandler__slice_data(data) == ["This is a test"]

def test_slice_big_data():
    """Test that the data is sliced into 1024 byte chunks"""
    data = "*" * 4000
    data_handler = DataHandler(data)
    assert data_handler._DataHandler__slice_data(data)[0] == "*" * 1012
    assert len(data_handler._DataHandler__slice_data(data)) == (4000 // 1012 + 1)

def test_get_data_slice():
    """Test that the data slice is returned and the sequence number is incremented"""
    data = "*" * 4000
    data_handler = DataHandler(data)
    # 4000 // 1024 = 3
    for i in range(3):
        data, seq_num = data_handler.get_data_slice()
        assert data == "*" * 1012
        assert seq_num == i

def test_get_data_slice_no_more_slices():
    """Test that the data slice is returned and the sequence number is incremented"""
    data = "*" * 4000
    data_handler = DataHandler(data)
    # 4000 // 1024 = 3
    for i in range(3):
        data, seq_num = data_handler.get_data_slice()
        assert data == "*" * 1012
        assert seq_num == i

    _ = data_handler.get_data_slice() # get the last data slice and sequence number
    data, seq_num = data_handler.get_data_slice()
    assert data == None
    assert seq_num == i + 1

def test_get_next_seq_number():
    """Test that the current sequence number is returned"""
    data = "*" * 4000
    data_handler = DataHandler(data)
    # 4000 // 1024 = 3
    for i in range(3):
        data, seq_num = data_handler.get_data_slice()
        assert seq_num == i
    assert data_handler.get_next_seq_number() == 3

def test_get_full_data():
    """Test that the original data is returned"""
    data = "*" * 4000
    data_handler = DataHandler(data)
    assert data_handler.get_full_data() == data

def test_get_data_size():
    """Test that the size of the data is returned"""
    data = "*" * 4000
    data_handler = DataHandler(data)
    assert data_handler.get_data_size() == 4000