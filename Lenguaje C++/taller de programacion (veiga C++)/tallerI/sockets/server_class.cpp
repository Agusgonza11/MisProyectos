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

Servidor::Servidor(const char* puerto, const uint16_t x, const uint16_t y) : prototipo{x, y}, 
server{puerto}, peer{std::move(server.accept())}, protocolo{} {
	this->esta_cerrado = false;
}
	
	
bool Servidor::procesar_recibido(){
	uint8_t i; uint16_t x; uint16_t y;
	int bytes = this->peer.recibir(&i, 1, &this->esta_cerrado);
	if (bytes <= 0) return false;
	this->peer.recibir(&x, 2, &this->esta_cerrado);
	this->peer.recibir(&y, 2, &this->esta_cerrado);
	std::tuple<uint16_t, uint16_t> cordenadas = this->protocolo.deserializar_cordenadas(x, y);
	std::vector<uint16_t> errores = procesar_linea(i, std::get<0>(cordenadas),
														std::get<1>(cordenadas));
	responder_status(errores);
	return true;	
}
	
	
void Servidor::responder_status(std::vector<uint16_t> errores){
	if(errores.size() == 0){
		uint8_t positivo = 0;
		this->peer.enviar(&positivo , 1);
	} else {
		uint8_t negativo = 1;
		uint8_t cantidad_errores = 0;		
		for (std::size_t i = 0; i < errores.size(); i++) cantidad_errores++; 
		/*
		Me doy cuenta que esto es ineficiente pero no encontre forma de castear 
		el size sin asegurarme de perder datos en la reduccion de dimensiones
		*/
		cantidad_errores = cantidad_errores/2;
		this->peer.enviar(&negativo , 1);
		this->peer.enviar(&cantidad_errores , 1);
		for (std::size_t i = 0; i < errores.size(); i++) {
			uint16_t error = this->protocolo.serializar_error(errores[i]);
			this->peer.enviar(&error, 2);
		}
	}	
}
	
	
std::vector<uint16_t> Servidor::procesar_linea(const uint8_t instruccion, 
										uint16_t cord_x, uint16_t cord_y){
	std::vector<uint16_t> errores = this->prototipo.construir_edificio(instruccion, 
																	cord_x, cord_y);
	return errores;
}
	
	
bool Servidor::aceptar_entrada(){
	while(!this->esta_cerrado){
		bool esta_conectado = procesar_recibido();
		if(!esta_conectado) break;
		this->prototipo.imprimir_mapa();
	}
	return true;
}
	
