#include <stdio.h>
#include <typeinfo>
#include <string>
#include <exception>
#include <errno.h>
#include "common_socket_error.h"

SocketError::SocketError(const std::string &error) noexcept {
	this->tipo_error = error;
}

const char* SocketError::what() const noexcept{
	return this->tipo_error.c_str();
}

SocketError::~SocketError(){}
