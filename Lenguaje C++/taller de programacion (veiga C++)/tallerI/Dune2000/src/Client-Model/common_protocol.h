#ifndef COMMON_PROTOCOL_H
#define COMMON_PROTOCOL_H
#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>
#include <map>
#include "common_unit.h"
#include "common_trike.h"
#include "common_tank.h"
//#include "common_socket.h"
#include "common_ground.h"
#include "common_frames.cpp"
#include "../Server/mock_server.h"

class Protocol {
	MockServer server;
	Skins skins;

	void create_unit_by_team(std::map <int, Unit*> &units, struct RawUnit &unit_received, int side);

	void updateUnits(std::map <int, Unit*> &units, struct RawUnit &unit_received);

	void appendUnits(std::map <int, Unit*> &units, struct RawUnit &unit_received, int team);

	public:
	Protocol();
	
	Ground receive_grounds();
	
	std::vector<struct RawUnit> receive_units(std::map <int, Unit*> &units, int team);
	
	void send_unit_attack(int unit_id, int unit_target_id);
	
	void send_unit_move(int unit_id, float cordX, float cordY);
	
	void update();

    void createTrike();



	//SERIALIZE -----------------------------------------------------------------------------
	/*
	uint8_t Protocol::receive_player_code(Socket &socket);

	*/
};
#endif
