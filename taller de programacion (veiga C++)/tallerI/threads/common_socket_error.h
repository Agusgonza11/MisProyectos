#ifndef SOCKET_ERROR_H
#define SOCKET_ERROR_H
#include <stdio.h>
#include <typeinfo>
#include <string>
#include <errno.h>
#include <exception>



class SocketError : public std::exception {
	std::string tipo_error;
	public:
	explicit SocketError(const std::string &error) noexcept;
	
	virtual const char *what() const noexcept;
	
	virtual ~SocketError() noexcept;   
};

#endif
