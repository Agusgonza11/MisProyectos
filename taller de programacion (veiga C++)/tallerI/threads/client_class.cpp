#include <iostream>
#include <string>
#include <fstream>
#include "common_socket.h"
#include <arpa/inet.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <cstring>
#include <tuple>
#include "common_protocolo.h"
#include "client.h"
#include <vector>
#include <sstream>

Cliente::Cliente(const char* hostname, const char* servicio) : conexion{hostname, servicio},
protocolo{} {
	this->esta_cerrado = false;
}


std::vector<std::string> Cliente::tokenizar_linea(std::string& linea){
    std::vector<std::string> tokens;
    std::stringstream check(linea);
    std::string intermediate;
    //NOLINTNEXTLINE
    while(getline(check, intermediate, ' ')){
    	tokens.push_back(intermediate);
    }
    return tokens;
}


void Cliente::imprimir_creacion(){
	uint8_t ret = this->protocolo.recibir_ret(this->conexion, 
												&esta_cerrado);
	if(ret == 0){
		std::cout << "Creacion exitosa\n";
	}
	if(ret == 1){
		std::cout << "Creacion fallida\n";	
	}
}

void Cliente::imprimir_union(){
	uint8_t ret = this->protocolo.recibir_ret(this->conexion, 
											&esta_cerrado);
	if(ret == 0){
		std::cout << "Union exitosa\n";
	}
	if(ret == 1){
		std::cout << "Union fallida\n";	
	}
}

void Cliente::imprimir_listado(){
	uint16_t count = this->protocolo.recibir_cantidad_partidas(this->conexion, 
													&esta_cerrado);
									
	for(uint16_t i = 0 ; i < count ; i++){
		std::tuple<uint8_t, uint8_t, std::string> tupla = 
		this->protocolo.recibir_listado_partidas(this->conexion, &esta_cerrado);
		int c = std::get<0>(tupla); int r = std::get<1>(tupla);
		std::cout << std::get<2>(tupla) << " " << c << "/" << r << "\n";
	}	
}


bool Cliente::leer_orden(std::string linea){
	std::vector<std::string> tokens = tokenizar_linea(linea);
	if(tokens[0] == "fin"){
		return false;
	} 
	if(tokens[0] == "listar"){
		this->protocolo.listar_partidas(this->conexion);
		imprimir_listado();
	} 
	if(tokens[0] == "crear"){
		this->protocolo.crear_partida(this->conexion, tokens);
		imprimir_creacion();
	}
	if(tokens[0] == "unirse"){
		this->protocolo.unirse_partida(this->conexion, tokens);
		imprimir_union();
	}
	return true;
}

	
bool Cliente::procesar_entrada(){
	std::string linea;
	while(true){
		getline(std::cin, linea);
		if(!leer_orden(linea)) break;
		if(this->esta_cerrado) break;
	}
	this->conexion.shutdown(0);
	return true;
}


