#ifndef SOCKET_H
#define SOCKET_H

/*Se aclara que parte del código utilizado para
la clase Socket forma parte del material dado por
la cátedra */

class Socket{
    int skt;
    bool closed;
    explicit Socket(int skt);
 public:
    Socket();
    Socket(const char* host, const char* servicename);
    explicit Socket(const char *servicename);
    void shutdown(int how);
    int close();
    ~Socket();
    Socket accept();
    int recieve(void *data, unsigned int sz);
    int sendd(const void* data, unsigned int sz);
    Socket(const Socket&) = delete;
    Socket& operator=(const Socket&) = delete;
    Socket(Socket&&);
    Socket& operator=(Socket&&);
};

#endif
