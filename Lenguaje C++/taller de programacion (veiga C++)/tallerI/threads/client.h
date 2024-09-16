#ifndef CLIENT_CLASS_H
#define CLIENT_CLASS_H
#include <vector>
#include <string>
#include "common_protocolo.h"
#include "common_socket.h"
#include <tuple>

class Cliente {
    Socket conexion;
    bool esta_cerrado;
    Protocolo protocolo;
    
    /*
    Recibe el "ret" de parte del servidor e imprime el resultado
    de la creacion que habia ordenado el cliente
    */
    void imprimir_creacion();
	
	/*
    Recibe el "ret" de parte del servidor e imprime el resultado
    de la union que habia ordenado el cliente
    */
	void imprimir_union();
	
	/*
	Recibe del server el listado de partidas y la imprime
	*/
	void imprimir_listado();
    
    /*
    Tokeniza lo leido por entrada estandar formando todas las palabras
    parseadas en un vector
    */
    std::vector<std::string> tokenizar_linea(std::string& linea);
	
	/*
	Procesa lo recibido por entrada estandar y ejecuta la orden
	que encuentra en ella
	*/
	bool leer_orden(std::string linea);
	
	public:
	/*
	Crea el cliente y realiza la conexion al servidor
	*/
	Cliente(const char* hostname, const char* servicio);
	
	/*
	Recibe por entrada estandar lo que escribe el cliente y lo envia 
	a procesar
	*/
	bool procesar_entrada();
};

#endif
