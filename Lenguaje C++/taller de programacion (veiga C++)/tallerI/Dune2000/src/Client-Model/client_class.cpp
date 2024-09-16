#include <iostream>
#include <string>
#include <fstream>
#include <arpa/inet.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <cstring>
#include <tuple>
#include "client_class.h"
#include <vector>
#include <sstream>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "common_protocol.h"
//#include "common_socket.h"
#include "common_model.h"
#include "common_game_screen.h"
#include <map>
#include "dunelogin.h"
#include <QApplication>

using namespace sf;

Client::Client(char* host, char* port): protocol{}, screen{} {}//, skt(host, port) {}
	
	
void Client::show_window(){
	//Sistema para unirse a partidas
    /*
    char *argv[] = {NULL};
    int argc = 1;
    QApplication a(argc, argv);
    DuneLogin w(&skt);
    w.show();
    a.exec();
     */
	int team = 0; //protocol.receive_player_code(socket);
	Ground ground = protocol.receive_grounds();
	std::map <int, Unit*> units;
	protocol.receive_units(units, team);
	Model model(units, ground, team);
	this->screen.show(model, this->protocol);
	//this->conexion.shutdown(0);
}


