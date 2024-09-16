class AckMessage:
    """Confirmation Message"""

    def __init__(self, sequence_number):
        self.sequence_number = sequence_number
        self.error_description = None

    @classmethod
    def error(cls, error_description):
        ack = cls(-1)
        ack.error_description = error_description
        return ack
    
    def has_error(self):
        return self.error_description != None