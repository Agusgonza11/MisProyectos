from datetime import datetime
from segments.segment import UDPSegment
from global_consts.constants import CLIENT_MAX_RETRY_TIMES, SR_CLIENT_TIMEOUT_TIME
from feedback.response import Response
from segments.segment_factory import UDPSegmentFactory

class WindowElement:
    def __init__(self, segment: UDPSegment, acked = False):
        self.segment = segment
        self.sent_time = datetime.now()
        self.retry_num = 0
        self.acked = acked

    def __repr__(self) -> str:
        return f"(segment: {self.segment.sequence_number}, sent_time: {self.sent_time}, retry_num: {self.retry_num})"

class Window:
    def __init__(self, size):
        self.size = size
        self.elements: [WindowElement] = [] # List<WindowElement>. Ordered by sent_time
        self.empty_spaces = size
        self.segment_factory = None

    def set_segment_factory(self, segment_factory: UDPSegmentFactory):
        """Sets the segment factory for the window, and initializes the window with segments from the factory"""
        self.segment_factory = segment_factory
        self.size = min(self.size, segment_factory.get_total_data_slices())
        for _ in range(0, self.size):
            new_segment = segment_factory.get_multiplexed_data_segment()
            if new_segment:
                self.add_new_segment(new_segment)

    def add_new_segment(self, segment, acked=False):
        """Adds a new segment to the window, decrementing the empty spaces counter."""
        self.__insert_sorted(WindowElement(segment, acked=acked))
        self.empty_spaces -= 1

    def get_sorted_elements(self, sort_by_seq_num=False) -> [WindowElement]:
        """Returns the elements of the window sorted by time.
        If sorte_by_seq_num is True, then the elements are sorted by sequence number."""
        return self.elements if not sort_by_seq_num else sorted(self.elements, key=lambda x: x.segment.sequence_number)

    def __insert_sorted(self, new_elem: WindowElement):
        """Inserts segment in the right position (sorted) in the window."""
        for i, window_element in enumerate(self.elements):
            if new_elem.sent_time < window_element.sent_time:
                self.elements.insert(i, new_elem)
                return
        self.elements.append(new_elem) # If segment is the last one, append it

    def ack_segment(self, seq_num):
        for window_elem in self.elements:
            if window_elem.segment.sequence_number != seq_num:
                continue
            window_elem.acked = True

    def update_segment(self, seq_num, time= datetime.now()) -> Response:
        """Updates the segment with the given sequence number.
        Time is optional, and defaults to datetime.now().
        Retry number is incremented by 1.
        If the segment has been retried more than MAX_RETRY_TIMES, returns Response.Error."""
        print("updating segment ", seq_num)
        for window_elem in self.elements:
            if window_elem.segment.sequence_number != seq_num:
                continue
            window_elem.sent_time = time
            window_elem.retry_num += 1
            
            if window_elem.retry_num > CLIENT_MAX_RETRY_TIMES:
                return Response.Error
            
            # Re-sorts the list because of the updated time
            self.elements.sort(key=lambda x: x.sent_time)
            return Response.Ok

    def remove_segment(self, seq_num) -> [WindowElement]:
        """Removes the segment with the given sequence number from the window.
        This means a ACK was received for said seq_num.
        When a segment is removed, a new one is added to the window.
        Returns the new segments added to the window."""
        print("window pre-remove: ", self)
        for i, window_elem in enumerate(self.elements):
            if window_elem.segment.sequence_number == seq_num:
                self.elements.pop(i)
                self.empty_spaces += 1
        # Add new segment to the window
        new_segments: [WindowElement] = []
        for i in range(self.empty_spaces):
            new_segment = self.segment_factory.get_multiplexed_data_segment()
            if new_segment:
                self.add_new_segment(new_segment)
                new_segments.append(WindowElement(new_segment))

        print("window post-remove: ", self)
        return new_segments
        
            
    def get_timedout_segment(self) -> [WindowElement]:
        """Returns the segments that have timed out, and therefore need to be resent."""
        timedout_segments: [WindowElement] = []
        for window_elem in self.elements:
            did_time_out = (datetime.now() - window_elem.sent_time).total_seconds() > SR_CLIENT_TIMEOUT_TIME
            if did_time_out and not window_elem.acked:
                return [window_elem]
            else:
                # Because the segments are sorted by time, if one is not timed out, then the following ones are not timed out either
                break
        return None
    
    def __repr__(self) -> str:
        seq_num = [x.segment.sequence_number for x in self.elements]
        return str(seq_num)