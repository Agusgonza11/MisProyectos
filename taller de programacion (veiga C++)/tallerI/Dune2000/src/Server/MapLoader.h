//
// Created by lucas on 12/06/22.
//

#ifndef EDITOR_MAPLOADER_H
#define EDITOR_MAPLOADER_H


#include <string>
#include <vector>


class MapLoader {
public:
    MapLoader();
    bool loadMapPreview(std::string& path,int& rows, int& cols,int&,std::string& name);
    //bool loadMap(std::string& path, std::vector<std::vector<int>>& map,int&,std::string& name, std::vector<ConstructionCenter*>& centers);
};


#endif //EDITOR_MAPLOADER_H
