#include <string>
#include <iostream>
#include <fstream>
#include <vector>
#include <iterator>
#include <tuple> 
#include "common_prototipo.h"


Prototipo::Prototipo(const uint16_t ancho, const uint16_t largo){
	this->largo = largo;
	this->ancho = ancho;
	for(uint16_t y=0 ; y<largo; y++){
		for(uint16_t x=0 ; x<ancho ; x++){
			this->matriz[y][x] = '.';
		}
	}
}
	
	
std::vector<uint16_t> Prototipo::verificar_suelo(const uint16_t cord_x, 
const uint16_t cord_y, const uint16_t despl_x, const uint16_t despl_y){
	std::vector <uint16_t> errores;
	for(uint16_t y=cord_y ; y < cord_y + despl_y; y++){
		for(uint16_t x=cord_x ; x < cord_x + despl_x; x++){
			if(this->ancho <= x || this->largo <= y){
				errores.push_back(x);
				errores.push_back(y);
			} else {
				/*
				Entiendo que esto puede ser desprolijo, lo mejor seria que este
				en un unico if, pero me pasaba que si comparaba un punto que 
				no se encontraba en la matriz (solo me pasaba con el primero
				nose porque) me saltaba conditional jump en valgrind.
				*/
				if(this->matriz[y][x] != '.'){
					errores.push_back(x);
					errores.push_back(y);
				}
			}
		}
	}
	return errores;
}
	
std::vector<uint16_t> Prototipo::agregar_silo(uint16_t cord_x,uint16_t cord_y){
	//if(cord_x >= this->ancho) cord_x = this->ancho -1;
	/*
	Estas lineas las habia introducido al principio pero no las borro porque
	me permitiria que "no se salga del mapa", para un futuro
	*/
	//if(cord_y >= this->largo) cord_y = this->largo -1;
	std::vector<uint16_t> errores = verificar_suelo(cord_x, cord_y, 1, 1);
	if(errores.size()==0){
		this->matriz[cord_y][cord_x] = 'S';
	} 
	return errores;
}
	
	
std::vector<uint16_t> Prototipo::agregar_cuartel(uint16_t cord_x, uint16_t cord_y){
	//if(cord_x >= this->ancho) cord_x = this->ancho -1;
	//if(cord_y >= this->largo) cord_y = this->largo -1;
	std::vector<uint16_t> errores = verificar_suelo(cord_x, cord_y, 2, 3);
	if(errores.size()==0){
		for(uint16_t y=cord_y ; y< cord_y + 3 ; y++){
			for(uint16_t x=cord_x ; x< cord_x + 2 ; x++){
				this->matriz[y][x] = 'C';
			}
		}
	}
	return errores;
}


std::vector<uint16_t> Prototipo::agregar_trampa(uint16_t cord_x, uint16_t cord_y){
	//if(cord_x >= this->ancho) cord_x = this->ancho -1;
	//if(cord_y >= this->largo) cord_y = this->largo -1;
	std::vector<uint16_t> errores = verificar_suelo(cord_x, cord_y, 3, 3);
	if(errores.size()==0){
		for(uint16_t y=cord_y ; y< cord_y + 3 ; y++){
			for(uint16_t x=cord_x ; x< cord_x + 3 ; x++){
				this->matriz[y][x] = 'T';
			}
		}
	} 
	return errores;
}

std::vector<uint16_t> Prototipo::construir_edificio(uint8_t instruccion, 
										uint16_t cord_x, uint16_t cord_y){
	std::vector<uint16_t> errores;
	if(instruccion == 1) errores = agregar_trampa(cord_x, cord_y);
	if(instruccion==2) errores = agregar_cuartel(cord_x, cord_y);
	if(instruccion==3) errores = agregar_silo(cord_x, cord_y);
	return errores;
}		
	
void Prototipo::imprimir_mapa(){
	for(uint16_t y=0 ; y<this->largo ; y++){
		for(uint16_t x=0 ; x<this->ancho ; x++){
			std::cout<< this->matriz[y][x];
		}
		std::cout<<"\n";
	}
	std::cout<<"\n";
}



