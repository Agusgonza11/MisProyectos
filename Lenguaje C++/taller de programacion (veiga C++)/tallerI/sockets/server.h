#ifndef SERVER_CLASS_H
#define SERVER_CLASS_H
#include <vector>

struct Servidor {
	Prototipo prototipo;
    Socket server;
    Socket peer;
    Protocolo protocolo;
	bool esta_cerrado;

	/*
	//Inicializa el servidor y la clase prototipo, quien contiene el sistema de juego.
	*/
	Servidor(const char* puerto, const uint16_t x, const uint16_t y);

	/*
	Acepta la entrada del cliente y devuelve un booleano en funcion 
	si se pudo o no realizar la conexion.
	*/
	bool aceptar_entrada();
	
	/*
	Recibe la instruccion de 5 bytes y envia a procesar las mismas,
	mientras siga recibiendo bytes la funcion devolvera true, en caso
	contrario devolvera false.
	*/
	bool procesar_recibido();
	
	/*
	Recibe la instruccion que contiene el edificio que se desea construir y la 
	posicion del mismo, y devuelve el vector de errores que contiene las
	posiciones en las que se intento construir y estan inhabilitadas, si se pudo
	construir correctamente el vector estara vacio.
	*/
	std::vector<uint16_t> procesar_linea(const uint8_t instruccion, 
	uint16_t cord_x, uint16_t cord_y);
	
	/*
	Recibe el vector con las posiciones inhabilitadas en las que se intento construir,
	la serializa y la envia al cliente para su proceso.
	*/
	void responder_status(std::vector<uint16_t> errores);
};

#endif
