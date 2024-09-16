#include <vector>
#include <string>
#include <tuple>
#include <map>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "common_unit.h"
#include <iostream>
#include "common_trike.h"
#include "common_tank.h"
#include "common_protocol.h"
#include "common_ground.h"
#include "../Server/mock_server.h"
#include <netinet/in.h>

#define ALIAD 0
#define ENEMY -1
#define BITS 16
#define HARKONNEN 1
#define ATREIDES 2
#define ORDOS 3 

Protocol::Protocol(): server{0, "a", 0}, skins{} {
	this->server.create_unit(0, 1, 0, 30);
	this->server.create_unit(1, 1, 5,30);
	this->server.create_unit(0, 2, 0, 10);
	this->server.create_unit(1, 1, 5,10);
}

Ground Protocol::receive_grounds(){
	vector<pair<struct map_coor, unsigned int>> terrains;
	for (unsigned int i = 60; i <= 100; i++)
		terrains.push_back(pair<struct map_coor, unsigned >({i, 60}, 1));
	this->server.load_map(terrains);

	std::vector<std::vector<int> > map;
	for(size_t row = 0; row <= 360; row++){
		std::vector<int> actual_row;
		for(size_t col = 0; col <= 360; col++){
			actual_row.push_back(0);
		}
		map.push_back(actual_row);
	}
	for(size_t i = 0; i < terrains.size(); i++){
		map[terrains[i].first.row][terrains[i].first.col] = terrains[i].second;
	}
	Ground grounds(map, 360, 360);
	return grounds;
}


void Protocol::updateUnits(std::map <int, Unit*> &units, struct RawUnit &unit_received){
	if(unit_received.state == "moving"){
		units[unit_received.id]->setMove(unit_received.col * BITS, unit_received.row * BITS);
	}
	if(unit_received.state == "attacking"){
 		if(units.count(unit_received.target_id) == 0) return;
		units[unit_received.id]->setAttack(units[unit_received.target_id]->get_position());
	} else if(unit_received.state == "neutral"){
		units[unit_received.id]->setNeutral();
	}
	units[unit_received.id]->modifyHp(unit_received.hp);
}


void Protocol::create_unit_by_team(std::map <int, Unit*> &units, struct RawUnit &unit_received, int side){
	switch(unit_received.team){
		case 0:
			units.insert(std::pair<int, Unit*>(unit_received.id, new TankClient(side, HARKONNEN, skins.tankH, skins.shoot, (int) unit_received.col * BITS, 
						(int) unit_received.row * BITS, unit_received.id, unit_received.player_id, unit_received.hp, skins.damage)));		
			break;
		case 1:
			units.insert(std::pair<int, Unit*>(unit_received.id, new TankClient(side, ATREIDES, skins.tankA, skins.shoot, (int) unit_received.col * BITS, 
						(int) unit_received.row * BITS, unit_received.id, unit_received.player_id, unit_received.hp, skins.damage)));		
			break;
		case 2:
			units.insert(std::pair<int, Unit*>(unit_received.id, new TankClient(side, ORDOS, skins.tankO, skins.shoot, (int) unit_received.col * BITS, 
						(int) unit_received.row * BITS, unit_received.id, unit_received.player_id, unit_received.hp, skins.damage)));		
			break;
	}
}


void Protocol::appendUnits(std::map <int, Unit*> &units, struct RawUnit &unit_received, int team){
	int side;
	if(team == (int) unit_received.player_id) side = ALIAD;
	else side = ENEMY;
	switch(unit_received.type_id){
		case 1:
			units.insert(std::pair<int, Unit*>(unit_received.id, new TrikeClient(side, skins.trike, skins.shoot, (int) unit_received.col * BITS, 
							(int) unit_received.row * BITS, unit_received.id, unit_received.player_id, unit_received.hp, skins.damage)));	
			break;
		case 2:
			//create_unit_by_team(units, unit_received, side);
			units.insert(std::pair<int, Unit*>(unit_received.id, new TankClient(side, HARKONNEN, skins.tankH, skins.shoot, (int) unit_received.col * BITS, 
						(int) unit_received.row * BITS, unit_received.id, unit_received.player_id, unit_received.hp, skins.damage)));		
			break;
	}
}
	
std::vector<struct RawUnit> Protocol::receive_units(std::map <int, Unit*> &units, int team){
	//std::vector<struct RawUnit> received_units = receive_state(socket);
	std::vector<struct RawUnit> received_units = this->server.get_state();
	for(size_t i = 0; i < received_units.size(); i++){
		int id_received = received_units[i].id;
		if(units.count(id_received) != 0){
			updateUnits(units, received_units[i]);
		} else {
			appendUnits(units, received_units[i], team);
		}
	}
	return received_units;
}


void Protocol::send_unit_attack(int unit_id, int unit_target_id){
	/*
	uint8_t order_attack = 2;
	uint64_t unit_player = htons(unit_id);
	uint64_t unit_enemy = htons(unit_target_id);
	socket.send(&order_attack, 1);
	socket.send(&unit_player, 4);
	socket.send(&unit_enemy, 4);
	*/
	this->server.unit_attack(unit_id, unit_target_id);
}


	
void Protocol::send_unit_move(int unit_id, float cordX, float cordY){
	/*
	uint8_t order_move = 1;
	uint64_t unit_player = htons(unit_id);
	uint32_t go_x = htons(cordX / BITS);
	uint32_t go_Y = htons(cordY / BITS);
	socket.send(&order_move, 1);
	socket.send(&unit_player, 4);
	socket.send(&go_x, 2);
	socket.send(&go_y, 2);
	*/
	this->server.move_unit(unit_id, (int) cordY / BITS, (int) cordX / BITS);
}

void Protocol::update(){
	this->server.update(10);
}

void Protocol::createTrike() {
    this->server.create_unit(0, 1, 10, 10);
}


//SERIALIZE -----------------------------------------------------------------------------

/*
uint8_t Protocol::receive_player_code(Socket &socket){
	uint8_t code;
	socket.recieve(&code, 1);
	return code;
}

Ground Protocol::receive_grounds(Socket &socket){
	uint64_t lenght_reveived; uint64_t widht_received; uint64_t lenght; uint64_t widht;
	socket.receive(&lenght_reveived, 4); 
	socket.receive(&widht_reveived, 4);
	lenght = ntohs(length_received);
	widht = ntohs(widht_received);
	std::vector<std::vector<int> > map;
	for(size_t row = 0; row <=  lenght; row++){
		std::vector<int> actual_row;
		for(size_t col = 0; col <= widht; col++){
			uint8_t actual;
			socket.receive(&actual, 1);
			actual_row.push_back(actual);
		}
		map.push_back(actual_row);
	}
	Ground grounds(map, 360, 360);
	return grounds;
}

std::vector<struct RawUnit> Protocol::receive_state(Socket &socket){
	std::vector<RawUnit> raw_units;
	struct RawUnit raw_unit;
	uint64_t size_received; uint64_t size;
	socket.receive(&size_received, 4);
	size = ntohs(size_received);
	for(size_t i = 0; i < size; i++){
		uint8_t id_unit;
		socket.receive(&id_unit, 1);
		raw_unit.id = id_unit;
		uint8_t playerCode;
		socket.receive(&playerCode, 1);
		raw_unit.player_id = playerCode;
		uint8_t team; //Este team se refiere a si es harkonnen ordos...etc
		socket.receive(&team, 1);
		raw_unit.player_id = playerCode;
		uint8_t type;
		socket.receive(&type, 1);
		raw_unit.type = type;
		uint8_t row;
		socket.receive(&row, 1);
		raw_unit.row = row;
		uint8_t col;
		socket.receive(&col, 1);
		raw_unit.col = col;
		uint8_t hp;
		socket.receive(&hp, 1);
		raw_unit.hp = hp;
		uint8_t state; uint8_t target;
		socket.receive(&state, 1);
		if(state == 2) socket.receive(&target, 1);
		else target = 0
		raw_unit.state = state;
		raw_unit.target = target;
	}
	return raw_units;
}


*/