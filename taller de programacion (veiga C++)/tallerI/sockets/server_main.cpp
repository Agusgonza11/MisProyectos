#include <iostream>
#include <string>
#include "common_socket.h"
#include <arpa/inet.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <cstring>
#include <tuple>
#include "common_prototipo.h"
#include "common_protocolo.h"
#include "server.h"

#define ERROR 1
#define SUCCESS 0


int main(int argc, char *argv[]){
	if(argc != 4) return ERROR;
	uint16_t x = std::stoi(argv[2]);
	uint16_t y = std::stoi(argv[3]);
	Servidor server(argv[1], x, y);
	if(!server.aceptar_entrada()) {
		return ERROR;
	}
	return SUCCESS;
}








