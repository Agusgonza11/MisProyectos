//
// Created by lucas on 15/05/22.
//

#ifndef CLIENT_CLIENTERROR_H
#define CLIENT_CLIENTERROR_H


class ClientError {
 public:
    virtual const char* what() const noexcept {
        return "formato: ./client <host> <servicename>";
    }
};


#endif
