#include <iostream>
#include <string>
#include <fstream>
#include <arpa/inet.h>
#include <stdlib.h>
#include <sys/socket.h>
#include "client_class.h"
#include "ClientError.h"
#include "../Common/SocketException.h"
#define ERROR 1
#define SUCCESS 0


int main(int argc, char *argv[]){
    try {
        if (argc != 3) throw ClientError();
        Client client(argv[1], argv[2]);
        client.show_window();
    }catch (const SocketException &e) {
        std::cout << e.what() << std::endl;
        return  1;
    } catch(const ClientError &e) {
        std::cout << e.what() << std::endl;
    }
    return 0;
}








