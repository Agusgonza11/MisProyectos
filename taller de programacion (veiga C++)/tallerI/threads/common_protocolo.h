#ifndef __COMMON_PROTOCOLO_H__
#define __COMMON_PROTOCOLO_H__

#include <string>
#include <fstream>
#include <vector>
#include <sstream>
#include <iostream>
#include <fstream>
#include "common_socket.h"
#include "common_partida.h"
#include <stdlib.h>
#include <cstring>
#include <tuple>
#include <map>

struct Protocolo {
	/*
	Convierte la casa ingresada en un byte
	*/
	uint8_t convertir_casa(std::string const &casa);
	
	/*
	Recibe el vector que contiene todas las palabras parte del nombre de la 
	partida y lo une en un string
	*/
	std::string serializar_nombre(std::vector<std::string> vector, size_t inicio);
	
	/*
	Calcula el largo del nombre de la partida
	*/
	uint16_t calcular_lend(std::vector<std::string> vector, size_t inicio);
	
	public:
	/*
	Envia al server la instruccion de unirse a una partida con todos los datos 
	necesarios
	*/
	void unirse_partida(Socket &socket, std::vector<std::string> vector);
	
	/*
	Envia al server la instruccion de crear partida con todos los datos necesarios
	*/
	void crear_partida(Socket &socket, std::vector<std::string> vector);
	
	/*
	Envia la orden de listar partida al server
	*/
	void listar_partidas(Socket &socket);
	
	/*
	Recibe del cliente la orden que se quiere ejecutar, ya sea crear, unirse o listar
	*/
	uint8_t recibir_orden(Socket &socket, bool &esta_cerrado);
	
	/*
	Le envia al cliente el listado de las partidas en curso
	*/
	void dar_listado_partidas(Socket &socket, std::map<std::string, Partida> partidas);
	
	/*
	Recibe el count del server
	*/
	uint16_t recibir_cantidad_partidas(Socket &socket, bool esta_cerrado);
	
	/*
	Recibe de parte del server el listado de partidas para su impresion
	desde el lado del cliente
	*/
	std::tuple<uint8_t, uint8_t, std::string> recibir_listado_partidas(
										Socket &socket, bool esta_cerrado);
							
	/*
	Recibe del cliente toda la instruccion de unirse a una partida y la devuelve 
	en forma de tupla	
	*/				
	std::tuple<uint8_t, std::string> recibir_orden_unirse(
									Socket &socket, bool esta_cerrado);
	
	/*
	Recibe del cliente toda la instruccion de crear una partida y la devuelve 
	en forma de tupla
	*/						
	std::tuple<uint8_t, uint8_t, uint16_t, std::string> recibir_orden_crear(
											Socket &socket, bool esta_cerrado);
	
	/*
	Le envia el ret al cliente
	*/
	void responder_ret(Socket &socket, uint8_t ret);
	
	/*
	Recibe el ret de parte del servidor
	*/
	uint8_t recibir_ret(Socket &socket, bool esta_cerrado);
};
#endif






