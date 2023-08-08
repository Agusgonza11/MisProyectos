//
// Created by lucas on 12/06/22.
//

#include "StateSaver.h"
#include "ConstructionCenter.h"
#include <yaml-cpp/yaml.h>
#include <fstream>

StateSaver::StateSaver() {
}

void StateSaver::saveStatus(std::string name,std::vector<std::vector<int>> map, int players, std::vector<ConstructionCenter*> centers) {
    YAML::Emitter out;
    out << YAML::BeginMap;
    out << YAML::Key << "name";
    out << YAML::Value << name;
    out << YAML::Key << "players";
    out << YAML::Value << players;
    std::vector<int> pos;
    pos.push_back(0);
    pos.push_back(1);
    int i = 0;
    for (auto & center : centers) {
        pos[0] = center->getPosition().x;
        pos[1] = center->getPosition().y;
        std::string number(std::to_string(i));
        out << YAML::Key << "players"+number;
        out << YAML::Value << pos;
        i++;
    }
    out << YAML::Key << "rows";
    out << YAML::Value << map.size();
    out << YAML::Key << "cols";
    out << YAML::Value << map[0].size();
    out << YAML::Key << "map";
    out << YAML::Value << map;

    out << YAML::EndMap;
    std::ofstream fout("../map/"+name+ ".yaml");
    fout << out.c_str();
}
