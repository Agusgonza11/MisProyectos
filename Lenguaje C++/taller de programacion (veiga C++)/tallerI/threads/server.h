#ifndef SERVER_CLASS_H
#define SERVER_CLASS_H

#include <vector>
#include <map>
#include <string>
#include "common_contenedor_partidas.h"

class Servidor {
    Socket server;
    ContenedorPartidas partidas;

	public:
	/*
	Crea la clase servidor y conecta el servidor pasivo en el puerto indicado
	*/
	explicit Servidor(const char* puerto);
	
	/*
	Crea el aceptador, le pasa el socket y la clase prototipo por referencia y
	se queda a la espera de un "q" para cortar el programa
	*/
	void aceptar_entrada();
};

#endif
