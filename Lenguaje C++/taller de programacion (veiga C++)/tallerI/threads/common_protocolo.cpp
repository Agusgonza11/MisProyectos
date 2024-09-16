#include <iostream>
#include <string>
#include <sstream>
#include <fstream>
#include "common_socket.h"
#include <stdlib.h>
#include <cstring>
#include "common_contenedor_partidas.h"
#include "common_partida.h"
#include <tuple>
#include <map>
#include <vector>
#include <netinet/in.h>

void Protocolo::listar_partidas(Socket &socket){
	uint8_t orden = 2;
	socket.enviar(&orden, 1);
}

uint8_t Protocolo::convertir_casa(std::string const &casa){
	/*
	No aplique el switch porque al parecer solo funciona con clases nativas
	no con strings
	*/
	uint8_t nuevo = -1;
	if(casa == "Harkonnen") nuevo = 0;
	if(casa == "Atreides") nuevo = 1;
	if(casa == "Ordos") nuevo = 2;
	return nuevo;
}

std::string Protocolo::serializar_nombre(std::vector<std::string> vector, size_t inicio){
	std::string nombre = "";
	for(size_t t = inicio; t < vector.size() ; t++){
		//NOLINTNEXTLINE
	    if(t > inicio){
	    	nombre += ' ';
	    }
        nombre += vector[t];
	}
	return nombre;
}
uint16_t Protocolo::calcular_lend(std::vector<std::string> vector, size_t inicio){
	uint16_t lend = 0;
	for(size_t t = inicio; t < vector.size() ; t++){
		//NOLINTNEXTLINE
	    if(t > inicio){
	    	lend += 1;
	    }
        lend += vector[t].size();
	}
	return lend;
}

void Protocolo::unirse_partida(Socket &socket, std::vector<std::string> vector){
	uint8_t casa = convertir_casa(vector[1]);
	uint8_t orden = 1;
	socket.enviar(&orden, 1);
	socket.enviar(&casa, 1);
	uint16_t lend = calcular_lend(vector, 2);
	uint16_t len = htons(lend);
	socket.enviar(&len, 2);
	std::string nombre = serializar_nombre(vector, 2);
	for(size_t i = 0 ; i < lend ; i++){
		socket.enviar(&nombre[i], 1);	
	}
}

void Protocolo::crear_partida(Socket &socket, std::vector<std::string> vector){
	uint8_t casa = convertir_casa(vector[1]);
	uint8_t orden = 3;
	socket.enviar(&orden, 1);
	socket.enviar(&casa, 1);
	uint8_t requeridos = std::stoi(vector[2]);
	socket.enviar(&requeridos, 1);
	uint16_t lend = calcular_lend(vector, 3);
	uint16_t len = htons(lend);
	socket.enviar(&len, 2);
	std::string nombre = serializar_nombre(vector, 3);
	for(size_t i = 0 ; i < lend ; i++){
		socket.enviar(&nombre[i], 1);	
	}
}

uint8_t Protocolo::recibir_orden(Socket &socket, bool &esta_cerrado){
	uint8_t orden; 
	int bytes = socket.recibir(&orden, 1, &esta_cerrado);
	if(bytes <= 0) return -1;
	return orden;
}

void Protocolo::dar_listado_partidas(Socket &socket, std::map<std::string, Partida> partidas){
	uint16_t cant = 0;
	for (size_t i = 0; i < partidas.size() ; i++) cant++;
	cant = htons(cant);
	socket.enviar(&cant, 2);
	for (const auto& [key, value] : partidas) {
		uint8_t actual = value.dar_actual();
		uint8_t requerido = value.dar_requerido();
		uint16_t largo = value.dar_largo();
		socket.enviar(&actual, 1);
		socket.enviar(&requerido, 1);
		uint16_t len = htons(largo);
		socket.enviar(&len, 2);
		for(uint16_t i = 0; i < largo ; i++){
			socket.enviar(&key[i], 1);
		}
    }
}

uint16_t Protocolo::recibir_cantidad_partidas(Socket &socket, bool esta_cerrado){
	uint16_t count;
	socket.recibir(&count, 2, &esta_cerrado);
	return ntohs(count);
}

std::tuple<uint8_t, uint8_t, std::string> Protocolo::recibir_listado_partidas(
										Socket &socket, bool esta_cerrado){
	uint8_t cur; uint8_t req; uint16_t name_len; std::string name = "";	
	socket.recibir(&cur, 1, &esta_cerrado);
	socket.recibir(&req, 1, &esta_cerrado);
	socket.recibir(&name_len, 2, &esta_cerrado);
	name_len = ntohs(name_len);
	for(uint16_t i = 0; i < name_len ; i++){
		uint8_t actual;
		socket.recibir(&actual, 1, &esta_cerrado);
		name += actual;
	}
	return std::make_tuple(cur, req, name);	
}

std::tuple<uint8_t, std::string> Protocolo::recibir_orden_unirse(
									Socket &socket, bool esta_cerrado){
	uint8_t casa; uint16_t name_len; std::string name = "";
	socket.recibir(&casa, 1, &esta_cerrado);
	socket.recibir(&name_len, 2, &esta_cerrado);
	name_len = ntohs(name_len);
	for(uint16_t i = 0; i < name_len ; i++){
		uint8_t actual;
		socket.recibir(&actual, 1, &esta_cerrado);
		name += actual;
	}
	return std::make_tuple(casa, name);
}

std::tuple<uint8_t, uint8_t, uint16_t, std::string> Protocolo::recibir_orden_crear(
												Socket &socket, bool esta_cerrado){
	uint8_t casa; uint8_t req; uint16_t name_len; std::string name = "";
	socket.recibir(&casa, 1, &esta_cerrado);
	socket.recibir(&req, 1, &esta_cerrado);
	socket.recibir(&name_len, 2, &esta_cerrado);
	name_len = ntohs(name_len);
	for(uint16_t i = 0; i < name_len ; i++){
		uint8_t actual;
		socket.recibir(&actual, 1, &esta_cerrado);
		name += actual;
	}
	return std::make_tuple(casa, req, name_len, name);
}

void Protocolo::responder_ret(Socket &socket, uint8_t ret){
	socket.enviar(&ret, 1);
}

uint8_t Protocolo::recibir_ret(Socket &socket, bool esta_cerrado){
	uint8_t ret;
	socket.recibir(&ret, 1, &esta_cerrado);
	return ret;
}





