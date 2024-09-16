#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <errno.h>

#include <sys/socket.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>
#include <iostream>
#include "Sockets.h"
#include "SocketException.h"
#include <exception>


#define SOCKET_CREATION "error en la creacion del socket"
#define BIND_ERROR "error en el bind"
#define ACCEPT_ERROR "error en el accept"
#define LISTEN_ERROR "error en el listen"
#define SHUT_ERROR "el apagado del socket fallo"
#define CLOSE_ERROR "el cerrado del socket fallo"
#define SEND_ERROR "error en el send"
#define RECIEVE_ERROR "error en el recieve"
#define CONNECTION_ERROR "error en la conexion"

Socket::Socket() {
    this->skt = -1;
    this->closed = true;
}

Socket::Socket(const char* host, const char* servicename) {
    int s;
    struct addrinfo hints;

    memset(&hints, 0, sizeof(struct addrinfo));
    hints.ai_family = AF_INET;       /* IPv4 (or AF_INET6 for IPv6)     */
    hints.ai_socktype = SOCK_STREAM; /* TCP  (or SOCK_DGRAM for UDP)    */
    hints.ai_flags = 0; /* AI_PASSIVE for server; 0 for client */

    struct addrinfo *result;
    struct addrinfo *rp;

    s = getaddrinfo(host, servicename, &hints, &result);
    if (s != 0) throw SocketException(SOCKET_CREATION);

    for (rp = result; rp != NULL; rp = rp->ai_next) {
        skt = socket(rp->ai_family, rp->ai_socktype, rp->ai_protocol);
        if (skt == -1)
            continue;

        s = connect(skt, rp->ai_addr, rp->ai_addrlen);
        if (s == -1) {
            freeaddrinfo(result);
            ::close(skt);
            throw SocketException(CONNECTION_ERROR);
        }



        this->closed = false;
        freeaddrinfo(result);
        return;
    }
}


Socket::Socket(const char* servicename) {
    int s;

    struct addrinfo hints;

    memset(&hints, 0, sizeof(struct addrinfo));
    hints.ai_family = AF_INET;       /* IPv4 (or AF_INET6 for IPv6)     */
    hints.ai_socktype = SOCK_STREAM; /* TCP  (or SOCK_DGRAM for UDP)    */
    hints.ai_flags = AI_PASSIVE; /* AI_PASSIVE for server; 0 for client */

    struct addrinfo *result;
    struct addrinfo *rp;

    s = getaddrinfo(NULL, servicename, &hints, &result);
    if (s != 0) throw std::runtime_error("error en la creacion del socket");

    for (rp = result; rp != NULL; rp = rp->ai_next) {
        skt = socket(rp->ai_family, rp->ai_socktype, rp->ai_protocol);
        if (skt == -1)
            continue;

        s = bind(skt, rp->ai_addr, rp->ai_addrlen);
        if (s == -1) {
            freeaddrinfo(result);
            ::close(skt);
            throw SocketException(BIND_ERROR);
        }

        s = listen(skt, 20);
        if (s == -1) {
            freeaddrinfo(result);
            ::close(skt);
            throw SocketException(LISTEN_ERROR);
        }

        this->closed = false;
        freeaddrinfo(result);
        return;
    }
}



void Socket::shutdown(int how) {
    if (::shutdown(this->skt, how) == -1) {
        throw SocketException(SHUT_ERROR);
    }
}

int Socket::close() {
    if (!this->closed) {
        this->closed = true;
        return ::close(this->skt);
    }
    throw SocketException(CLOSE_ERROR);
}

Socket::~Socket() {
    if (this->skt != -1) {
        ::shutdown(this->skt, 2);
        ::close(this->skt);
    }
}


int Socket::send(const void* data, unsigned int sz) {
    if (sz == 0) {
        return 0;
    }

    unsigned int bytes_sent = 0;

    while (bytes_sent < sz) {
        int bytes;
        bytes = ::send(this->skt, (char*) data +
                                bytes_sent , sz-bytes_sent, MSG_NOSIGNAL);

        if (bytes == -1) {
            throw SocketException(SEND_ERROR);
        } else if (bytes == 0) {
            return bytes;
        }
        bytes_sent += bytes;
    }
    return sz;
}


int Socket::recieve(void *data, unsigned int sz) {
    if (sz == 0) {
        return 0;
    }

    unsigned int bytes_recieved = 0;
    while (bytes_recieved < sz) {
        int bytes;
        bytes = recv(this->skt, (char *) data +
                                bytes_recieved, sz - bytes_recieved, 0);

        if (bytes == -1) {
            throw SocketException(RECIEVE_ERROR);
        } else if (bytes == 0) {
            return bytes;
        }
        bytes_recieved += bytes;
    }

    return sz;
}

Socket Socket::accept() {
    int skt = ::accept(this->skt, nullptr, nullptr);
    if (skt == -1) {
        throw SocketException(ACCEPT_ERROR);
    }
    return Socket(skt);
}

Socket& Socket::operator=(Socket&& other) {
    if (this == &other)
        return *this;

    if (!this->closed) {
        ::shutdown(this->skt, 2);
        ::close(this->skt);
    }
    this->skt = other.skt;
    this->closed = other.closed;

    other.skt = -1;
    other.closed = true;

    return *this;
}

Socket::Socket(int skt) {
    this->skt = skt;
    this->closed = false;
}

Socket::Socket(Socket&& other) {
    this->skt = other.skt;
    this->closed = other.closed;

    other.skt = -1;
    other.closed = true;
}
