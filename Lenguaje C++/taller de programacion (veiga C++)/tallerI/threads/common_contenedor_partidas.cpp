#include <iostream>
#include <string>
#include "common_socket.h"
#include <arpa/inet.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <cstring>
#include <tuple>
#include "common_protocolo.h"
#include "common_contenedor_partidas.h"
#include "common_partida.h"
#include <thread>       
#include <mutex>  
#include <map>  


void ContenedorPartidas::unirse_partidas_server(Socket &socket){
	uint8_t ret = 1;
	std::tuple<uint8_t, std::string> tupla = 
		this->protocolo.recibir_orden_unirse(socket, &esta_cerrado);
	if(this->partidas.count(std::get<1>(tupla)) == 0){
		ret = 1;
	} else {
		std::string buscado = std::get<1>(tupla);
		std::map<std::string, Partida>::iterator iterador;
		for(iterador = this->partidas.begin(); iterador != this->partidas.end(); ++iterador){
			std::string clave = iterador->first;
			if(clave == buscado){
				Partida partida = iterador->second;
				ret = partida.dar_estado();
				this->partidas.erase(buscado);
				this->partidas.insert({buscado, partida});
				break;
			}
		}
	}
	this->protocolo.responder_ret(socket, ret);
}

	/*
	Se que esta funcion seria mejor que la ocupe la clase partida,
	pero era mas practico de esta forma ya que sino tendria que 
	crear un objeto partida simplemente para hacer este checkeo
	*/
bool ContenedorPartidas::casa_valida(uint8_t casa){
	return casa == 0 || casa == 1 || casa == 2;
}

void ContenedorPartidas::crear_partidas_server(Socket &socket){
	uint8_t ret;
	std::tuple<uint8_t, uint8_t, uint16_t, std::string> tupla = 
				this->protocolo.recibir_orden_crear(socket, &esta_cerrado);
	if(this->partidas.count(std::get<3>(tupla)) != 0 || 
					!casa_valida(std::get<0>(tupla))){
		ret = 1;
	} else {		
		std::string nombre = std::get<3>(tupla);
		Partida partida(std::get<1>(tupla), std::get<2>(tupla), nombre);
		this->partidas.insert({nombre, partida});
		ret = 0;
	}
	this->protocolo.responder_ret(socket, ret);
}
		
bool ContenedorPartidas::procesar_recibido(Socket &socket, bool esta_cerrado){
	while(!esta_cerrado){
		uint8_t orden = this->protocolo.recibir_orden(socket, esta_cerrado);
		if (orden == -1) return false;
		const std::lock_guard<std::mutex> lock(this->mtx);
		if(orden == 1){
			unirse_partidas_server(socket);
		}
		if(orden == 2){
			this->protocolo.dar_listado_partidas(socket, partidas);	
		}
		if(orden == 3){
			crear_partidas_server(socket);
		}
	}
	return true;	
}



