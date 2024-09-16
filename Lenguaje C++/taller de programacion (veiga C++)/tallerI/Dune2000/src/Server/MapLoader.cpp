//
// Created by lucas on 12/06/22.
//

#include <yaml-cpp/yaml.h>
#include <iostream>

#include "MapLoader.h"

MapLoader::MapLoader() {

}

/*
bool MapLoader::loadMap(std::string& path, std::vector<std::vector<int>>& map, int& players, std::string& names) {
    YAML::Node config = YAML::LoadFile(path);
    map = config["map"].as<std::vector<std::vector<int>>>();
    players = config["players"].as<int>();
    name = config["name"].as<std::string>();
    for (int i = 0; i < players ; ++i) {
        std::string number(std::to_string(i));
        auto *c = new ConstructionCenter();
        auto n= config["players"+ number].as<std::vector<int>>();
        c->setPosition(n[0],n[1]);
        centers.push_back(c);
    }
    return true;
}
 */

bool MapLoader::loadMapPreview(std::string &path, int &rows, int &cols, int &players, std::string &name) {
    YAML::Node config = YAML::LoadFile(path);
    players = config["players"].as<int>();
    name = config["name"].as<std::string>();
    rows = config["rows"].as<int>();
    cols = config["cols"].as<int>();
    return true;
}
