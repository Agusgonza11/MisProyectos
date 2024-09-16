//
// Created by lucas on 12/06/22.
//

#ifndef EDITOR_STATESAVER_H
#define EDITOR_STATESAVER_H
#include <string>
#include <vector>
#include "ConstructionCenter.h"

class StateSaver {
public:
    StateSaver();
    void saveStatus(std::string name, std::vector<std::vector<int>> map, int players, std::vector<ConstructionCenter*> centers);
};


#endif //EDITOR_STATESAVER_H
