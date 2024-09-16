#ifndef __COMMON_PROTOTIPO_H_
#define __COMMON_PROTOTIPO_H__

#include <string>
#include <fstream>
#include <vector>
#include <tuple>


struct Prototipo {
	uint16_t ancho;
	uint16_t largo;
	char matriz[1000][1000]; 
	/*
	Entiendo que esto esta mal, deberia poder tener cualquier tamaño, 
	pero no sabia de que forma dejarlo inicializado 
	al estilo member initialization list.
	*/

	/*
	Inicializa el prototipo, la estructura que controla toda la logica del juego.
	*/
    Prototipo(const uint16_t ancho, const uint16_t largo);

	/*
	Recibe una instruccion del edificio a corregir y unas cordenadas y lo ejecuta.
	*/
	std::vector<uint16_t> construir_edificio(uint8_t instruccion, 
										uint16_t cord_x, uint16_t cord_y);

    /*
    Devuelve un vector con todas los posiciones inhabilitadas en las que se intento
    construir, de estar todas las posiciones disponibles, y por lo tanto, habilitada
    la construccion, el vector que devuelve estara vacio.
    */
	std::vector<uint16_t> verificar_suelo(const uint16_t cord_x, const uint16_t cord_y, 
    									const uint16_t despl_x, const uint16_t despl_y);

	/*
    Agrega un silo en las cordenadas predispuestas, de no poder hacerlo, 
    imprimira la posicion inhabilitada.
    */
	std::vector<uint16_t> agregar_silo(uint16_t cord_x, uint16_t cord_y);
    
    /*
    Agrega un cuartel en las cordenadas predispuestas, de no poder hacerlo, 
    imprimira todas las posiciones inhabilitadas.
    */
    std::vector<uint16_t> agregar_cuartel(uint16_t cord_x, uint16_t cord_y);
    
    /*
    Agrega una trampa de aire en las cordenadas predispuestas, de no 
    poder hacerlo, imprimira todas las posiciones inhabilitadas.
    */
    std::vector<uint16_t> agregar_trampa(uint16_t cord_x, uint16_t cord_y);
    
    /*
    Imprime el estado actual del mapa.
    */
    void imprimir_mapa();
};
#endif
