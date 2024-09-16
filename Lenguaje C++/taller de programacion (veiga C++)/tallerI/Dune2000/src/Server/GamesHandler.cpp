//
// Created by lucas on 26/06/22.
//

#include "GamesHandler.h"
#include "mock_server.h"
#include <iostream>

//Game es el modelo de la partida y receiver la blockingqueue que recibe todas las instrucciones
/*
template<class T>
void GamesHandler::push_order(const T &val){
    receiver.push(val);
}

template<class T>
void GamesHandler::update(){
    T order = receiver.pop();
    game.apply_order(order); //Aplico esa instruccion al servidor
}

template<class T>
T GamesHandler::send_state(){
    T state = game.get_state();
    return state;
}
*/

//Esto esta mal pero lo guardo por si llega a servir --------------------------------------------------
/*
bool GamesHandler::create_game(std::string gameName, int limitPlayers, std::string playerName, int team){
    if(games.count(gameName) > 0) return false;
    games.insert(std::pair<std::string, MockServer*>(gameName, new MockServer(limitPlayers, playerName, team)));	
}

bool GamesHandler::join_game(std::string gameName, std::string playerName, int team){
    if(games.count(gameName) == 0) return false;
    return games[gameName]->addPlayer(playerName, team);
}

void GamesHandler::list_games(){
    for(auto iter = games.begin(); iter != games.end(); ++iter){
		std::tuple<int, int> status = iter->second->listGame();
        std::cout << iter->first << " " << std::get<1>(status) << "/" << std::get<0>(status);
	}	
}
*/