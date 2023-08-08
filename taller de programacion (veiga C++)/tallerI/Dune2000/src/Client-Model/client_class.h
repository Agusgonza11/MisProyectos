#ifndef CLIENT_CLASS_H
#define CLIENT_CLASS_H
#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "common_protocol.h"
//#include "common_socket.h"
#include "../Common/Sockets.h"
#include "common_model.h"
#include "common_game_screen.h"

class Client {
    Protocol protocol;
    GameScreen screen;
    Socket skt;
	public:
	Client(char*,char*);
	void show_window();
};
#endif
