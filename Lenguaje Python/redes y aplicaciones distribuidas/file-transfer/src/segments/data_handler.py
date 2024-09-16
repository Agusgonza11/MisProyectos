# This is a Stop and Wait protocol, so we need to keep track of the sequence numbers
class DataHandler:
    def __init__(self, data):
        self.sequence_number = 0
        self.data = data
        self.data_slices = self.__slice_data(data)
        self.total_data_slices = len(self.data_slices)

    @staticmethod
    def __slice_data(data):
        """Breaks the data into data_slices of 1012 bytes"""
        # TODO should this be a bigger size? Check Maximum Transmission Unit (MTU)
        data_slices = []
        for i in range(0, len(data), 1012):
            data_slices.append(data[i:i+1012])
        return data_slices

    def get_data_slice(self, recv_seq_num=None):
        """Returns the next data_slice in the sequence and the sequence number. If there are no more data_slices, returns None"""

        print(self.total_data_slices)

        # If the sequence number is bigger than the number of slices, return None
        if not self.seq_num_is_valid(self.sequence_number):
            # -1 because we want the last sequence number sent
            return None, self.sequence_number - 1

        # If the received sequence number is valid and bigger than the current sequence number, update the current sequence number
        # This prevents sending duplicated data to the server and saves time when having multiple clients
        if self.recv_seq_num_is_valid(recv_seq_num):
            self.sequence_number = recv_seq_num

        data_slice = self.data_slices[self.sequence_number]
        return_sequence_number = self.sequence_number
        self.sequence_number += 1
        return data_slice, return_sequence_number

    def seq_num_is_valid(self, seq_num):
        """Returns True if the sequence number is valid, False otherwise"""
        return seq_num != None and seq_num < self.total_data_slices

    def recv_seq_num_is_valid(self, recv_seq_num):
        return self.seq_num_is_valid(recv_seq_num) and recv_seq_num > self.sequence_number

    def get_next_seq_number(self):
        """Returns the next sequence number to be sent"""
        return self.sequence_number

    def get_full_data(self):
        """Returns the original data, no slices"""
        return self.data

    def get_data_size(self):
        """Returns the size of the data in bytes"""
        return len(self.data)

    def is_last_slice(self):
        """Returns True if the current sequence number is the last one, False otherwise"""
        return self.sequence_number == self.total_data_slices

    def get_total_data_slices(self):
        """Returns the total number of data slices"""
        return self.total_data_slices
