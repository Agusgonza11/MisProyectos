#include <iostream>
#include <string>
#include <fstream>
#include "common_socket.h"
#include <arpa/inet.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <cstring>
#include <tuple>
#include "common_prototipo.h"
#include "common_protocolo.h"
#include "client.h"

Cliente::Cliente(const char* hostname, const char* servicio) : conexion{hostname, servicio},
protocolo{} {
	this->esta_cerrado = false;
}

	
void Cliente::imprimir_errores(std::vector<uint16_t> errores){	    
	std::cout<< "Lugar Insuficiente. Posiciones bloqueadas:";
	for(size_t i = 0; i < errores.size() ; i=i+2){
		std::cout<< " (" << errores[i] << "," << errores[i+1]<< ")";
	}
    std::cout<<"\n";
}

std::tuple<uint8_t, uint16_t, uint16_t> Cliente::tokenizar_linea(std::string linea) {
    int contador = 0;
    std::string palabra = "";
    uint8_t instruccion; uint16_t cord_x; uint16_t cord_y;
    for (auto x: linea) {
        if (x == ' ') {
        	if(contador == 0 && palabra.size() != 0) {
    			instruccion = std::stoi(palabra);
    		}
    		if(contador == 1 && palabra.size() != 0) {
    			cord_x = std::stoi(palabra);
    		}
        	if(palabra.size() != 0) {
        		contador++;
        	}
            palabra = "";
        } else {
            palabra = palabra + x;
        }
    }
    cord_y = std::stoi(palabra);
    return std::make_tuple(instruccion, cord_x, cord_y);
}

	
void Cliente::enviar_orden(std::string const linea){
	std::tuple<uint8_t, uint16_t, uint16_t> tokenizado = tokenizar_linea(linea);
	std::tuple<uint16_t, uint16_t> serializado = this->protocolo.serializar_orden(
								std::get<1>(tokenizado), std::get<2>(tokenizado));
	this->conexion.enviar(&std::get<0>(tokenizado) , 1);
	this->conexion.enviar(&std::get<0>(serializado) , 2);
	this->conexion.enviar(&std::get<1>(serializado) , 2);
}

void Cliente::recibir_errores(){
	std::vector<uint16_t> errores;
	uint8_t cantidad;
	this->conexion.recibir(&cantidad, sizeof(cantidad), &this->esta_cerrado); 
	for(uint8_t i = 0; i < cantidad * 2 ; i++){
		uint16_t error_actual;
		this->conexion.recibir(&error_actual, 2, &this->esta_cerrado); 
		uint16_t error = this->protocolo.deserializar_error(error_actual);
		errores.push_back(error);
	}
	imprimir_errores(errores);	
}

void Cliente::recibir_status(){
	uint8_t status; 
	this->conexion.recibir(&status, sizeof(status), &this->esta_cerrado); 
	if(status==0){
		std::cout << "Construccion Exitosa\n";
	} else {
		recibir_errores();
	}
}
		
	
bool Cliente::procesar_entrada(const char* nombre_archivo){
	std::string linea;
	std::ifstream archivo(nombre_archivo);
	if(!archivo.is_open()) return false;
	while(getline(archivo, linea)){
		enviar_orden(linea);
		recibir_status();
		if(this->esta_cerrado) break;
	}
	archivo.close();	
	this->conexion.shutdown(0);
	return true;
}




