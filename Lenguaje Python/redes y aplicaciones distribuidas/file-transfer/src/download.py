import os
from client.selective_repeat import SelectiveRepeatDownloader
from parser.arguments import client_arguments
from client.stop_and_wait import StopAndWaitDownloader
import socket
from feedback.response import Response


def start_client(client_handler):
    """This function starts the client and handles the file download."""
    try:
        response = client_handler.handle()
        if response == Response.Ok:
            print(
                f"File is now at: {client_handler.file_destination}/{client_handler.file_name}")

    except Exception as exception:
        print(f"Error: {exception}")

    finally:
        client_handler.socket.close()
        print("Connection closed")


def main():
    args = client_arguments()

    client_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    if args.prot is None or args.prot.upper() == 'SW':
        client_handler = StopAndWaitDownloader(
            args.host, args.port, args.file, client_socket, args.dst, args.name)
    elif args.prot.upper() == 'SR':
        client_handler = SelectiveRepeatDownloader(
            args.host, args.port, args.file, client_socket, args.dst, args.name)
    else:
        raise Exception("Invalid protocol. Valid protocols are SW and SR.")

    if client_handler.file_exists():
        print("File already exists in selected destination. Please change the file's name or folder.")
        return

    start_client(client_handler)


if __name__ == "__main__":
    main()
