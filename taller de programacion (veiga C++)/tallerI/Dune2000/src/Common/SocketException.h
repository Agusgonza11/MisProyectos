//
// Created by lucas on 15/05/22.
//

#ifndef _SOCKETEXCEPTION_H
#define _SOCKETEXCEPTION_H

#include <exception>
#include <iostream>
#include <string>


class SocketException : std::exception {
 private:
    std::string error_msg;
 public:
    explicit SocketException(const std::string& error_msg) noexcept;
    virtual const char* what() const noexcept;
    virtual ~SocketException() noexcept;
};


#endif
