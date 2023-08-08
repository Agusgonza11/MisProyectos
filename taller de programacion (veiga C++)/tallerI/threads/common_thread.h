#ifndef __COMMON_THREAD_H__
#define __COMMON_THREAD_H__

#include <iostream>
#include <vector>
#include <thread>
#include <mutex>
#include "common_socket.h"
#include "common_contenedor_partidas.h"

class Thread{
    std::thread thread;
    Socket socket;
    bool esta_cerrado;
    ContenedorPartidas &partidas;
	
	Thread& operator=(const Thread&& other);
	public:
    Thread(Socket recibido, ContenedorPartidas &partidas);

    bool finalizo();

    void lanzar();

     void join();
        

     void run();
   
     //virtual ~Thread() = 0;

     Thread(const Thread&);
     //Thread& operator=(const Thread&);
};
#endif

