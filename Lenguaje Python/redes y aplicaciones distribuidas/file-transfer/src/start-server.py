from parser.arguments import server_arguments
from feedback.ack import AckMessage
from feedback.messages import DownloadMessage, Message, UploadMessage
import pickle
from segments.segment import UDPSegment
from server.server import Server
import socket
from global_consts.constants import SW_SERVER_TIMEOUT_TIME, SR_SERVER_TIMEOUT_TIME, FILE_NOT_FOUND_ERROR, FILE_ALREADY_UPLOADED, SW_WINDOW_SIZE, SR_WINDOW_SIZE, SERVER_MAX_RETRY_TIMES

def run_server(args, window_size):
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    server = Server(args.host, args.port, args.storage, window_size)
    server_socket.bind((args.host, int(args.port)))

    print(f"Server listening on {args.host}:{args.port}")

    data = None
    max_retries = 0
    timer = SR_SERVER_TIMEOUT_TIME if window_size > 1 else SW_SERVER_TIMEOUT_TIME
    try:
        while True:
            try:
                server_socket.settimeout(timer) 
                serialized_data, address = server_socket.recvfrom(1500)
            except TimeoutError:
                # Server only times out here when waiting for segment. So it resends ACK.
                # For downloads, server handles timesout in send_file
                if data and isinstance(data, Message) and data.is_upload():
                    if max_retries > SERVER_MAX_RETRY_TIMES:
                        print("Max retries exceeded. Server closing client conection.")
                        data = None
                        max_retries = 0
                        continue
                    print("Server timed out waiting for segments.")
                    print("Sending ACK again for", server.get_last_seq_number_for_upload(data.full_path()))
                    ack_msg = AckMessage(server.get_last_seq_number_for_upload(data.full_path()))
                    server_socket.sendto(pickle.dumps(ack_msg), address)
                    max_retries += 1
                continue

            deserialized_data = pickle.loads(serialized_data)
            print("Message length:", len(serialized_data))

            if isinstance(deserialized_data, Message):
                print("Message is download or upload")
                data: Message = deserialized_data
                data, max_retries = handle_message(data, server, server_socket, address, max_retries)
            
            elif isinstance(deserialized_data, AckMessage):
                print("message is ACK")
                data: AckMessage = deserialized_data
                if (not data) or data.has_error() or data.sequence_number < 0:
                    print("> Finished")
                    data = None
                    max_retries = 0
                    continue
                else:
                    continue_download(data, server, server_socket, address)
                
            else:
                raise Exception("Unknown message type received.")
            

    except KeyboardInterrupt:
        print("Server shutting down...")
    finally:
        server_socket.close()
        print("Server has shut down.")

def handle_message(data: Message, server: Server, server_socket: socket, address, max_retries):
    if data.is_download():
        print("\nDownload request received.")
        if server.file_is_available(data.full_path()):
            print("file is available")
            server.open_segments(data, server_socket, address)
        else:
            print("> File is not available")
            server_socket.sendto(pickle.dumps(UDPSegment.error(FILE_NOT_FOUND_ERROR)), address)
            return (None, 0)

    if data.is_upload():
        print("\nUpload request received.")

        if server.file_is_available(data.full_path()):
            print("File is already on server. No overwriting allowed.")
            server_socket.sendto(pickle.dumps(AckMessage.error(FILE_ALREADY_UPLOADED)), address)
            return (None, 0)


        returned_seq_num, upload_complete = server.upload(data)
        ack_msg = AckMessage(returned_seq_num)
        server_socket.sendto(pickle.dumps(ack_msg), address)
        # Check if this is ok: if is last_segment, server does not need to send ack in repeat
        if upload_complete:
            print("> Upload finished.")
            server.mark_as_finished(data)
            data = None
            max_retries = 0
    return (data, max_retries)

def continue_download(data: AckMessage, server: Server, server_socket: socket, address):
    server.confirm_ack(data, server_socket, address)


def main():
    args = server_arguments()
    try:
        
        if args.prot is None or args.prot.upper() == 'SW':
            window_size = SW_WINDOW_SIZE
        elif args.prot.upper() == 'SR':
            window_size = SR_WINDOW_SIZE
        else:
            raise Exception("Invalid protocol. Valid protocols are SW and SR.")

        run_server(args, window_size)
    except Exception as exception:
        print(f"Error when attempting to start the server: {str(exception)}")


if __name__ == "__main__":
    main()
