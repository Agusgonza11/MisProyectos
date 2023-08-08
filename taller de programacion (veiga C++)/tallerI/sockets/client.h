#ifndef CLIENT_CLASS_H
#define CLIENT_CLASS_H
#include <vector>
#include <string>
#include "common_protocolo.h"
#include "common_socket.h"
#include <tuple>

struct Cliente {
    Socket conexion;
    bool esta_cerrado;
    Protocolo protocolo;

    /*
    Inicializa el cliente, conectando el socket al del servidor.
    */
    Cliente(const char* hostname, const char* servicio);

	/*
	Lee una por una las lineas del archivo y las procesa para enviarlas al servidor,
	luego recibe la respuesta del mismo. Si hubo un error en la apertura del 
	archivo devolvera false.
	*/
	bool procesar_entrada(const char* nombre_archivo);

	/*
	Tokeniza lo leido en la linea del archivo para ser serializado por el 
	protocolo
	*/
	std::tuple<uint8_t, uint16_t, uint16_t> tokenizar_linea(std::string linea);

	/*
    Lee la linea en la que se encuentra el archivo en ese momento.
    Serializa la misma y la envia al servidor.
    */
    void enviar_orden(std::string linea);

	/*
	Recibe el status del servidor, lo deserializa, e imprime por salida estandar
	el resultado del mismo.
	*/
	void recibir_status();

	/*
	En caso de que el status recibido a la orden realizada haya sido 1, recibe todas
	las posiciones inhabilitadas, las deserializa y las imprime.
	*/
	void recibir_errores();

	/*
    Imprime por salida estandar todas las posiciones en que se intento 
    construir y no estan disponibles.
    */
   	void imprimir_errores(std::vector<uint16_t> errores);
};

#endif
