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
	if(argc != 4) return ERROR;
	Cliente cliente(argv[1], argv[2]);
	cliente.procesar_entrada(argv[3]);
	return SUCCESS;
}








