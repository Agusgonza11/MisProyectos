#include <iostream>
#include <string>
#include <sstream>
#include <fstream>
#include "common_socket.h"
#include <stdlib.h>
#include <cstring>
#include "common_protocolo.h"
#include <tuple>
#include <vector>
#include <netinet/in.h>

std::tuple<uint16_t, uint16_t> Protocolo::serializar_orden(uint16_t cord_x, uint16_t cord_y) {
    return std::make_tuple(htons(cord_x), htons(cord_y));
}

std::tuple<uint16_t, uint16_t> Protocolo::deserializar_cordenadas(uint16_t cord_x, 
																uint16_t cord_y) {
	return std::make_tuple(ntohs(cord_x), ntohs(cord_y));
}

uint16_t Protocolo::serializar_error(uint16_t posicion) {
	return htons(posicion);
}

uint16_t Protocolo::deserializar_error(uint16_t posicion) {
	return ntohs(posicion);
}

