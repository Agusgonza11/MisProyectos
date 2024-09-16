//
// Created by lucas on 26/06/22.
//
#ifndef SERVER_GAMESHANDLER_H
#define SERVER_GAMESHANDLER_H
#include "mock_server.h"
#include "blocking_queue.h"

class GamesHandler {
    //std::map<std::string, MockServer*> games;
    MockServer game;
    BlockingQueue<class T> receiver;
    
    public:
/*
    void push_order(const T &val);

    void update();

    T send_state();
*/
    /*
    bool create_game(std::string gameName, int limitPlayers, std::string playerName, int team);

    bool join_game(std::string gameName, std::string playerName, int team);

    void list_games();
    */
};


#endif //SERVER_GAMESHANDLER_H
