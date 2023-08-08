#ifndef __COMMON_PARTIDA_H__
#define __COMMON_PARTIDA_H__

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

class Partida {
	uint8_t actual;
	uint8_t requerido;
	uint16_t largo;
	std::string nombre;

	/*
	Imprime si la partida ya se lleno y por lo tanto esta comenzando
	*/
	void imprimir_estado();
	
	/*
	Aumenta en uno el current de la partida
	*/
	void unirse();
	
	public:
	/*
	Crea la clase partida 
	*/
	Partida(uint8_t req, uint16_t len, std::string const &nombre);
	
	/*
	Getter del actual numero de jugadores
	*/
	uint8_t  dar_actual() const;
	
	/*
	Getter del necesario numero de jugadores
	*/
	uint8_t dar_requerido() const;
	
	/*
	Getter del largo del nombre de la partida
	*/
	uint16_t dar_largo() const;
	
	/*
	Checkea que la partida no esta completa, si lo esta devolvera 1, en
	caso contrario se unira y devolvera 0
	*/
	uint8_t dar_estado();
	
	/*
	Checkea si la partida esta completa
	*/
	bool esta_completa();
};
#endif

