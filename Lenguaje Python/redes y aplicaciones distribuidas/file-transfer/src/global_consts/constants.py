# Timers
SERVER_RECHECK_TIME = 2

# Paths
INDEX_STORAGE_PATH = "storage_info/"
INDEX_STORAGE_FILE_PATH = "index.txt"

# Errors
FILE_NOT_FOUND_ERROR = "File not found on Server. Please recheck the file path and try again"
FILE_ALREADY_UPLOADED = "File is already uploaded on the server. Please try again with a different file name."
MAX_TRIES_EXCEEDED  = "Max retries exceeded."

# Message Size
MAX_MESSAGE_SIZE = 1024

# Stop and Wait
SW_WINDOW_SIZE = 1
SW_CLIENT_TIMEOUT_TIME = 0.05
SW_SERVER_TIMEOUT_TIME = 0.10

# Selective Repeat
SR_WINDOW_SIZE = 4
SR_CLIENT_TIMEOUT_TIME = 1
SR_SERVER_TIMEOUT_TIME = 2
CLIENT_MAX_RETRY_TIMES = 50
SERVER_MAX_RETRY_TIMES = 15