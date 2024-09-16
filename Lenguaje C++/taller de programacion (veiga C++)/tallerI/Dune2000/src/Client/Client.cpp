//
// Created by lucas on 21/05/22.
//

#include "Client.h"
#include "loginscreen.h"
#include <yaml-cpp/yaml.h>
#include <fstream>
#include <iostream>
#include <string>
#include <QApplication>

Client::Client(const char* host , const char* port): skt(host, port){}

void Client::run() {
    loginScreen();
}

void Client::loginScreen() {
    char *argv[] = {NULL};
    int argc = 1;
    QApplication b(argc, argv);
    LoginScreen w;
    w.show();
    b.exec();
}

void Client::changeResolution(unsigned int height, unsigned int width) {
    YAML::Node node, _baseNode = YAML::LoadFile("../config/config.yaml"); // gets the root node
    _baseNode["resolution"]["height"]= height;
    _baseNode["resolution"]["width"] = width;
    std::ofstream fout("../config/config.yaml");
    fout << _baseNode;
}