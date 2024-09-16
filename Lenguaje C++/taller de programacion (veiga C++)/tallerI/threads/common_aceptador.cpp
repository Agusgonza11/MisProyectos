#include "common_aceptador.h"
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
#include <utility>
#include <condition_variable>
#include "common_socket_error.h"

Aceptador::Aceptador(Socket &socket, ContenedorPartidas &partidas) : 
		pasivo(socket), partidas(partidas) {}
	
	
void Aceptador::esperarHilosManejadores(){
	for(std::size_t i = 0; i < hilos.size(); i++){
		hilos[i]->join();
		delete(hilos[i]);
	}
}
	
void Aceptador::limpiarManejadoresFinalizados(){
	for(size_t i = 0; i < this->hilos.size(); i++){
		if(this->hilos[i]->finalizo()){
			this->hilos[i]->join();
			delete(hilos[i]);
			this->hilos.erase(this->hilos.begin()+i);
		}
	}
}
	
void Aceptador::atenderClientes(){
	bool esta_cerrado = false;
	while(!esta_cerrado){
		try{
			Socket peer = this->pasivo.accept();
			hilos.push_back(new Thread(std::move(peer), this->partidas));
			hilos.back()->lanzar();
			limpiarManejadoresFinalizados();
		} catch(...){
			esta_cerrado = true;
		}
	}
	esperarHilosManejadores();
}



