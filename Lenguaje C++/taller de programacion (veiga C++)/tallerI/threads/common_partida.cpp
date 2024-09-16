#include <iostream>
#include <string>
#include <sstream>
#include <fstream>
#include "common_socket.h"
#include <stdlib.h>
#include <cstring>
#include "common_protocolo.h"
#include "common_partida.h"
#include <tuple>
#include <vector>
#include <netinet/in.h>


Partida::Partida(uint8_t req, uint16_t len, std::string const &nombre): 
		actual{1}, requerido{req}, largo{len}, nombre{nombre} {}

void Partida::imprimir_estado(){
	if(esta_completa()){
		std::cout << "Comenzando partida " << this->nombre << "...\n";
	}
}

uint8_t Partida::dar_estado(){
	uint8_t ret;
	if(esta_completa()){
		ret = 1;
	} else {
		unirse();
		ret = 0;
		imprimir_estado();
	}
	return ret;
}

uint8_t Partida::dar_actual() const {
	return this->actual;
}

uint8_t Partida::dar_requerido() const {
	return this->requerido;
}

uint16_t Partida::dar_largo() const {
	return this->largo;
}

bool Partida::esta_completa(){
	return this->requerido == this->actual;
}

void Partida::unirse(){
	this->actual += 1;
}
