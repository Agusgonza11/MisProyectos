#ifndef __COMMON_PROTOCOLO_H__
#define __COMMON_PROTOCOLO_H__

#include <string>
#include <fstream>
#include <vector>
#include <sstream>
#include <iostream>
#include <fstream>
#include "common_socket.h"
#include <stdlib.h>
#include <cstring>
#include <tuple>

struct Protocolo {
	uint8_t instruccion;
	uint16_t cord_x;
	uint16_t cord_y;

	/*
	Recibe la linea actual del archivo, la tokeniza y la serializa 
	en una tira de 1 y 2 bytes para enviar al servidor. Devuelve la 
	misma en forma de tupla
	*/
	std::tuple<uint16_t, uint16_t> serializar_orden(uint16_t cord_x, uint16_t cord_y);
	
	/*
	Deserealiza el status recibido por el cliente para ver el estado
	de la construccion.
	*/
	int deserializar_status(uint8_t status);
	
	/*
	Deserealiza la cantidad de posiciones inhabilitadas en las que se
	intento construir, esta misma que es enviada junto al status.
	*/
	int deserializar_errores(uint16_t errores);
	
	/*
	Deserealiza las cordenadas enviadas por el cliente conviertiendo
	los endiannes y las devuelve en una tupla
	*/
	std::tuple<uint16_t, uint16_t> deserializar_cordenadas(uint16_t cord_x, uint16_t cord_y);
	
	/*
	Serializa la posicion inhabilitada para ser enviada al cliente.
	*/
	uint16_t serializar_error(uint16_t posicion);
	
	/*
	Deserializa la posicion inhabilitada enviada por el servidor para 
	su impresion.
	*/
	uint16_t deserializar_error(uint16_t posicion);
};
#endif






