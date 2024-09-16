import argparse


class Argument:
    def __init__(self, short_name, long_name, help_text) -> None:
        self.short_name = short_name
        self.long_name = long_name
        self.help_text = help_text


def accepted_shared_arguments():
    return [
        ('-v', '--verbose', 'increase output verbosity'),
        ('-q', '--quiet', 'decrease output verbosity'),
        ('-H', '--host', 'server IP address', "ADDR"),
        ('-p', '--port', 'service port', "PORT"),
        ('-pr', '--prot', 'rdt protocol. SW for Stop & Wait, or SR for Selective Repeat. Default is SW', "PROTOCOL")
    ]


def accepted_server_arguments():
    return [
        ('-s', '--storage', 'storage dir path', "DIRPATH"),
    ]


def accepted_client_arguments():
    return [
        ('-n', '--name', 'file name', "FILENAME"),
        ('-s', '--src', 'source file path', "FILEPATH"),
        ('-d', '--dst', 'destination file path', "FILEPATH"),
    ]


def add_argument(parser: argparse.ArgumentParser, argument):
    short_name = argument[0]
    long_name = argument[1]
    help_text = argument[2]
    metavar = argument[3] if len(argument) > 3 else None

    parser.add_argument(short_name, long_name, type=str,
                        help=help_text, metavar=metavar)


def is_mutually_exclusive_argument(argument_name):
    return argument_name == "-v" or argument_name == "-q"


def client_arguments():
    parser = argparse.ArgumentParser()

    total_accepted_arguments = accepted_client_arguments() + accepted_shared_arguments()
    parser.add_argument('file', help='Name of the file to send')
    add_arguments(parser, total_accepted_arguments)

    return parser.parse_args()


def server_arguments():
    parser = argparse.ArgumentParser()

    total_accepted_arguments = accepted_server_arguments() + accepted_shared_arguments()

    add_arguments(parser, total_accepted_arguments)

    return parser.parse_args()


def add_arguments(parser: argparse.ArgumentParser, arguments):
    group = parser.add_mutually_exclusive_group()
    for argument in arguments:
        if is_mutually_exclusive_argument(argument[0]):
            group.add_argument(argument[0], argument[1], help=argument[2])
        else:
            add_argument(parser, argument)
