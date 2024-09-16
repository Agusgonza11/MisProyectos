#ifndef __COMMON_CONTENEDOR_PARTIDAS_H__
#define __COMMON_CONTENEDOR_PARTIDAS_H__
#include <iostream>
#include <string>
#include "common_socket.h"
#include <arpa/inet.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <cstring>
#include <tuple>
#include <map>       
#include "common_protocolo.h"
#include "common_partida.h"
#include <thread>       
#include <mutex>  


class ContenedorPartidas {
	std::map<std::string, Partida> partidas;
	Protocolo protocolo;
	bool esta_cerrado;
	std::mutex mtx;

	/*
	Checkea que la casa ingresada para jugar es valida
	*/
	bool casa_valida(uint8_t casa);

	public:	
	ContenedorPartidas() : esta_cerrado(false) {}
	/*
	Recibe las instrucciones para unirse a una partida del cliente, la procesa
	y le responde con el "ret", es decir el resultado del proceso
	*/
	void unirse_partidas_server(Socket &socket);
	
	/*
	Recibe las instrucciones para crear una partida del cliente, la procesa
	y le responde con el "ret", es decir el resultado del proceso
	*/
	void crear_partidas_server(Socket &socket);
	
	/*
	Recibe la orden del cliente, dependiendo de cual sea la procesa y 
	la envia a ejecutar
	*/
	bool procesar_recibido(Socket &socket, bool esta_cerrado);
};
#endif
