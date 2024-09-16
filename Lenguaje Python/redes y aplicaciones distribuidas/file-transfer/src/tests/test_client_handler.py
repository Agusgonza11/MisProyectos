from enum import Enum
import pickle
import unittest
import os
import socket
import tempfile

from global_consts.constants import MAX_MESSAGE_SIZE

# We need to remove this Enum. 
# The reason I copied and pasted it here was because I was getting an error when I tried to import it from message.py

class CommandType(Enum):
    UPLOAD = 1
    DOWNLOAD = 2


class TestSendFile(unittest.TestCase):
    def setUp(self):
        # Create a temporary storage directory for testing
        self.temp_storage = tempfile.mkdtemp()

        # Set up a test server socket (use a free port)
        self.server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.server_socket.bind(("127.0.0.1", 0))  # Bind to a random free port
        self.server_port = self.server_socket.getsockname()[1]

    def test_send_file(self):
        # Create a temporary test file with some content
        test_file_path = "test_file.txt"
        with open(test_file_path, "wb") as test_file:
            test_file.write(b"Test data for file upload.")

        client_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

        upload_message = {
            'command_type': CommandType.UPLOAD,
            'message': b"Test data for file upload."
        }

        client_socket.sendto(pickle.dumps(upload_message), ("127.0.0.1", self.server_port))
        received_data, _ = self.server_socket.recvfrom(MAX_MESSAGE_SIZE)
        received_message = pickle.loads(received_data)

        self.assertEqual(received_message['command_type'], CommandType.UPLOAD)
        self.assertEqual(received_message['message'], b"Test data for file upload.")

        # Clean up the temporary test file
        os.remove(test_file_path)

if __name__ == "__main__":
    unittest.main()
