#ifndef CLIENT_CLASS_H
#define CLIENT_CLASS_H
#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "common_protocol.h"
#include "common_socket.h"
#include "common_model.h"
#include "common_game_screen.h"

class Client {
    ProtocolGame protocol;
    Socket conexion;
    bool was_closed;
    GameScreen screen;
    
	public:
	Client(const char* hostname, const char* service);

	void show_window();
};
#endif
