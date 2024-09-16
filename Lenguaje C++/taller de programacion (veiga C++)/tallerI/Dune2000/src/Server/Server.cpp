//
// Created by lucas on 26/06/22.
//

#include <string>
#include <iostream>
#include <sys/socket.h>
#include <thread>
#include <vector>
#include "Server.h"
#include "../Common/SocketException.h"
#include "ClientHandler.h"

#define END  "q"

Server::Server(const char *servicename):skt(servicename), is_running(true){
}

Server::~Server() {
}

void Server::send_state(){
    
}

void Server::listener() {
    while (is_running) {
        try {
            Socket accept = skt.accept();
            auto *nuevo = new ClientHandler(std::move(accept), &gamesHandler);
            gamesHandler.update();
            nuevo->start();
            clients.push_back(nuevo);
            auto it = clients.begin();
            actual_state = gamesHandler.send_state(); //Obtengo el estado actual del juego
            for(size_t i = 0; i < clients.size(); i++){
                clients[i].send(actual_state); //Envio el estado a cada uno de los clientes
            }
            while (it != clients.end()) {
                if ((*it)->isOver()) {
                    (*it)->stop();
                    (*it)->join();
                    delete *it;
                    it = clients.erase(it);
                } else {
                    ++it;
                }
            }

        } catch (SocketException &e) {
            break;
        }
    }

    for (int i = 0; i < (int) clients.size(); ++i) {
        clients[i]->stop();
        clients[i]->join();
        delete clients[i];
    }

}

template<class T>
void Server::run() {
    std::thread acceptor(&Server::listener, this);
    while (is_running){
        std::string str;
        std::getline(std::cin, str);
        if (str == END) {
            is_running = false;
            skt.shutdown(SHUT_RDWR);
        }
    }
    acceptor.join();
}
