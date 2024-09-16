//
// Created by lucas on 26/06/22.
//

#ifndef PROTOCOL_H
#define PROTOCOL_H

#include "../Common/Sockets.h"

class Protocol {

public:
    Protocol();
    int decodeLoginInstruction(Socket& socket, bool& was_closed);
    void sendMapList();

    /*
    void send_player_code(Socket &socket);

    void send_terrain(Socket &socket);

    void send_units(Socket &socket);

    uint8_t receive_order(Socket &socket);

    void receive_unit_move(Socket &socket);

    void receive_unit_attack(Socket &socket);
    */
};


#endif
