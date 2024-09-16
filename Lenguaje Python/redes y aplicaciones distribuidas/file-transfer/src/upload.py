import os
from client.selective_repeat import SelectiveRepeatUploader
from parser.arguments import client_arguments
from client.stop_and_wait import StopAndWaitUploader
import socket
from feedback.response import Response


def start_client(client_handler):
    """This function starts the client and handles the file upload."""
    try:

        response = client_handler.handle()
        if response == Response.Ok:
            print(f"File '{client_handler.file_name}' was sent successfully")

    except Exception as exception:
        print(f"Error starting_client: {exception}")

    finally:
        client_handler.socket.close()
        print("Connection closed")


def main():
    """This function is the entry point of the client upload."""
    args = client_arguments()

    if not os.path.exists(args.file):
        print("> File not found.")
        return

    client_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    if args.prot is None or args.prot.upper() == 'SW':
        client_handler = StopAndWaitUploader(
            args.host, args.port, args.file, client_socket, args.src, args.name)
    elif args.prot.upper() == 'SR':
        client_handler = SelectiveRepeatUploader(
            args.host, args.port, args.file, client_socket, args.src, args.name)
    else:
        raise Exception("Invalid protocol. Valid protocols are SW and SR.")

    start_client(client_handler)


if __name__ == "__main__":
    main()
