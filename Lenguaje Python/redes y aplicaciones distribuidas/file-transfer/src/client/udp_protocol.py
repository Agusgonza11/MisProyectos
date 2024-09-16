from abc import ABC, abstractmethod


class UDPProtocol(ABC):
    """This class encapsulates the shared logic between the upload client and the download client.
    """

    def __init__(self, host, port, file, socket) -> None:
        self.host = host
        self.port = port
        self.file = file
        self.socket = socket

    @abstractmethod
    def handle(self):
        """This function handles the client."""
        pass
