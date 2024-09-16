#include <iostream>
#include <string>
#include "common_socket.h"
#include <arpa/inet.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <cstring>
#include <tuple>
#include "common_contenedor_partidas.h"
#include "server.h"
#include "common_aceptador.h"
#include <condition_variable>


Servidor::Servidor(const char* puerto): server{puerto}, partidas{} {}
	
void Servidor::aceptar_entrada(){
	Aceptador aceptador(this->server, this->partidas);
	std::thread hiloAceptador(&Aceptador::atenderClientes, aceptador);
	std::string ingresado;
	while(true){
		getline(std::cin, ingresado);
		if(ingresado == "q") break;
	}
	this->server.shutdown(0);
	hiloAceptador.join();
}
	
