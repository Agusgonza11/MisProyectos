//
// Created by lucas on 15/05/22.
//

#include "SocketException.h"
#include <string>

SocketException::SocketException(const std::string &error_msg)
noexcept :error_msg(error_msg) {
}
const char* SocketException::what() const noexcept {
    return this->error_msg.c_str();
}

SocketException::~SocketException() {
}
