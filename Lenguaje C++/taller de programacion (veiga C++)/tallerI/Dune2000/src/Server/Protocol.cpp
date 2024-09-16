//
// Created by lucas on 26/06/22.
//

#include <cstdint>
#include "Protocol.h"
#define OPERATION 1

Protocol::Protocol() = default;

int Protocol::decodeLoginInstruction(Socket &socket, bool& was_closed) {
    uint8_t command;
    if (!socket.recieve(&command, OPERATION)) {
        was_closed = true;
        return -1;
    }

    return (int) command;
}

/*
void ProtocolServer::send_player_code(Socket &socket){
    uint8_t playerCode; //Esto ya lo tendrias
    socket.send(&playerCode, 1);
}

void ProtocolServer::send_terrain(Socket &socket){
    uint64_t lenght; uint64_t widht; //Esto ya lo tendrias
	socket.receive(&htons(lenght), 4); 
	socket.receive(&htons(widht), 4);
	std::vector<std::vector<uint8_t> > map; //Esto ya lo tendrias
	for(size_t row = 0; row <=  lenght; row++){
		for(size_t col = 0; col <= widht; col++){
			socket.send(&map[row][col], 1);
		}
	}
}

void ProtocolServer::send_units(Socket &socket){
    uint64_t size; //Esto ya lo tendrias
	socket.send(&htons(size), 4);
	for(size_t i = 0; i < size; i++){ //Todos los uint8_t que declaro aca serian los atributos de cada unidad que tengas vos, es decir units[i].(atributo)
		uint8_t id_unit;
		socket.send(&id_unit, 1);
		uint8_t playerCode;
		socket.send(&playerCode, 1);
		uint8_t team; //Este team se refiere a si es harkonnen ordos...etc
		socket.send(&team, 1);
		uint8_t type;
		socket.send(&type, 1);
		uint8_t row;
		socket.send(&row, 1);
		uint8_t col;
		socket.send(&col, 1);
		uint8_t hp;
		socket.send(&hp, 1);
		uint8_t state; uint8_t target;
		socket.send(&state, 1);
		if(state == 2) socket.send(&target, 1);
    }
}

uint8_t ProtocolServer::receive_order(Socket &socket){
	uint8_t order;
	socket.receive(&order, 1);
	return order;
}

void ProtocolServer::receive_unit_move(Socket &socket){
    uint64_t unit_player_received; uint32_t go_x_received; uint32_t go_Y_received;
    socket.receive(&unit_player_received, 4);
    socket.receive(&go_x_received, 2);
    socket.receive(&go_y_received, 2);
	uint64_t unit_player = ntohs(unit_player_received);
	uint32_t go_x = ntohs(go_x_received);
	uint32_t go_Y = ntohs(go_y_received);
    //y aca tendrias que ver que haces con esos tres datos
}

void ProtocolServer::receive_unit_attack(Socket &socket){
    uint64_t unit_player_received; uint64_t unit_enemy_received;
	socket.receive(&unit_player_received, 4);
	socket.receive(&unit_enemy_received, 4);
	uint64_t unit_player = ntohs(unit_player_received);
	uint64_t unit_enemy = ntohs(unit_enemy_received);
    //y aca tendrias que ver que haces con esos dos datos
}
*/