//
// Created by lucas on 15/05/22.
//

#ifndef _SERVER_SERVERERROR_H
#define _SERVER_SERVERERROR_H


class ServerError {
 public:
    virtual const char* what() const noexcept {
        return "formato: ./server <servicename>";
    }
};


#endif
