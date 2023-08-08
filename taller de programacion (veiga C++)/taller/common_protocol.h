#ifndef COMMON_PROTOCOL_H
#define COMMON_PROTOCOL_H
#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "common_units.h"
#include "common_socket.h"
#include "common_grounds.h"
#include "mock_server.h"

class Protocol {
	MockServer server;
	bool received;

	public:
	Protocol(): received_units(false);
	
	std::vector<Ground*> receive_grounds();
	
	
	std::vector<Unit*> receive_units();
	
	
	void send_unit_move(Unit &unit, float cordX, float cordY);
	
	void update();
}
#endif
