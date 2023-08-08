#include <iostream>
#include <string>
#include "common_socket.h"
#include <arpa/inet.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <cstring>
#include <tuple>
#include "server.h"

#define SUCCESS 0
#define ERROR 1


int main(int argc, char *argv[]){
	if(argc <= 0) throw "Argumentos insuficientes";
	try{
		Servidor server(argv[1]);
		server.aceptar_entrada();
	} catch (std::exception &excepcion) {
		std::cout << excepcion.what() << "\n";
		return ERROR;
	}
	return SUCCESS;
}








