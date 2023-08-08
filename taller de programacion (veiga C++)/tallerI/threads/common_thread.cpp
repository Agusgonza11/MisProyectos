#include <iostream>
#include <vector>
#include <thread>
#include <mutex>
#include <utility>
#include "common_socket.h"
#include "common_thread.h"


Thread::Thread(Socket recibido, ContenedorPartidas &partidas) : 
    socket(std::move(recibido)), esta_cerrado{false}, partidas(partidas){
}

bool Thread::finalizo(){
    return this->esta_cerrado;
}

void Thread::lanzar() {
    thread = std::thread(&Thread::run, this);
}

void Thread::join() {
	this->socket.shutdown(0);
    this->thread.join();
}
        
void Thread::run(){
	bool cerrado = this->partidas.procesar_recibido(this->socket, this->esta_cerrado);
    this->esta_cerrado = cerrado;
}
   
//Thread::~Thread() {}

//Thread& Thread::operator=(const Thread&) = delete;

//Thread& Thread::operator=(const Thread&& other) {
//    this->thread = std::move(other.thread);
//    return *this;
//}




