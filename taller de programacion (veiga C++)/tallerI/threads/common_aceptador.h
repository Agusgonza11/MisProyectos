#ifndef __COMMON_ACEPTADOR_H__
#define __COMMON_ACEPTADOR_H__

#include <iostream>
#include <string>
#include <sstream>
#include <fstream>
#include "common_socket.h"
#include <stdlib.h>
#include <cstring>
#include "common_contenedor_partidas.h"
#include "common_thread.h"
#include <tuple>
#include <map>
#include <vector>
#include <netinet/in.h>
#include <algorithm>

class Aceptador{
	std::vector<Thread*> hilos;
	Socket &pasivo;
	ContenedorPartidas &partidas;
	
	public:
	/*
	Joinea todos los hilos
	*/
	void esperarHilosManejadores();
	
	/*
	Crea la clase aceptador
	*/
	Aceptador(Socket &socket, ContenedorPartidas &partidas);
	
	/*
	Checkea que no quedo ningun hilo suelto que ya haya finalizado, si
	lo hay, lo joinea y elimina de la lista
	*/
	void limpiarManejadoresFinalizados();
	
	/*
	Conecta el socket y lanza el hilo del cliente, tambien lo añade a un
	vector que contiene todos los hilos
	*/
	void atenderClientes();
};
#endif

