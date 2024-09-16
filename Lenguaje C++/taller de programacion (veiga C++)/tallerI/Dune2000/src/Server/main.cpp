#include <iostream>
#include <mutex>
#include "Server.h"
#include "../Common/SocketException.h"
#include "ServerError.h"

int main(int argc, char const *argv[]) {
    try {
        if (argc != 2) throw ServerError();
        Server server(argv[1]);
        server.run();
    } catch (const ServerError& e) {
        std::cout<< e.what() <<std::endl;
        return 1;
    } catch (const SocketException &e) {
        std::cout << e.what() << std::endl;
    }
    return 0;
}