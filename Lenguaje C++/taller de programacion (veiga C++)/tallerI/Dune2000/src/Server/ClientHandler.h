//
// Created by lucas on 26/06/22.
//

#ifndef CLIENTHANDLER_H
#define CLIENTHANDLER_H


#include <atomic>
#include "Thread.h"
#include "GamesHandler.h"
#include "Protocol.h"

class ClientHandler: public Thread {
private:
    Protocol pr;
    Socket peer;
    std::atomic<bool> is_over;
    GamesHandler* game;
    //BlockingQueue sender;


public:
    void run() override;
    void stop() override;
    bool isOver();
    ClientHandler(Socket skt, GamesHandler *gamesHandler);
    ClientHandler(const ClientHandler&) = delete;
    ClientHandler& operator=(const ClientHandler&) = delete;
};


#endif
