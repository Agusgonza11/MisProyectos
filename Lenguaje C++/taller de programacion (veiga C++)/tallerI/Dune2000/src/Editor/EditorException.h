//
// Created by lucas on 17/06/22.
//

#ifndef EDITOR_EDITOREXCEPTION_H
#define EDITOR_EDITOREXCEPTION_H


#include <string>

class EditorException {
private:
    std::string error_msg;
public:
    explicit EditorException(const std::string& error)
            : error_msg(error) {}
    virtual const char* what() const throw() {
        return error_msg.c_str();
    }
};


#endif //EDITOR_EDITOREXCEPTION_H
