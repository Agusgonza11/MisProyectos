#include <iostream>
#include <string>
#include <fstream>
#include <arpa/inet.h>
#include <stdlib.h>
#include <sys/socket.h>
#include "client.h"

#define ERROR 1
#define SUCCESS 0


int main(int argc, char *argv[]){
	//if(argc <= 1) throw "Argumentos insuficientes";
	try{
		Client client(argv[1], argv[2]);
		client.show_window();
	} catch (std::exception &excepcion) {
		std::cout << excepcion.what() << "\n";
		return ERROR;
	}
	return SUCCESS;
}








