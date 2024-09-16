//
// Created by lucas on 26/06/22.
//

#include <sys/socket.h>
#include "ClientHandler.h"
#include "GamesHandler.h"
#include "../Common/SocketException.h"

#define JOIN_GAME 1
#define LIST_GAMES 2
#define CREATE_GAME 3
#define LIST_MAPS 4


ClientHandler::ClientHandler(Socket skt, GamesHandler *gamesHandler)
        : is_over(false), game(gamesHandler) {
    this->peer = std::move(skt);
}

void ClientHandler::run() {
    while (!is_over) {
        try {

            bool was_closed = false;
            //game.push_order(pr.decodeLoginInstruction(peer, was_closed)); //Pusheo cada una de las ordenes en la blockingqueue recieve
            //int instr = pr.decodeLoginInstruction(peer, was_closed);
            this->is_over = was_closed;
            /*
            if (!is_over) {
                switch (instr) {
                    case JOIN_GAME:
                        break;
                    case LIST_GAMES:
                        break;
                    case CREATE_GAME:
                        break;
                    case LIST_MAPS:
                        //pr.sendMaps();
                        break;
                }
            }
            */

        } catch (SocketException &e) {
            is_over = true;
            std::cout<< e.what();
        }
    }
}

/*
void ClientHandler::send_state(const T &val){
    sender.push(val); //Pusheo el estado en la cola propia del cliente 
}*/

void ClientHandler::stop() {
    peer.shutdown(SHUT_RDWR);
    is_over = true;
}

bool ClientHandler::isOver() {
    return is_over;
}
