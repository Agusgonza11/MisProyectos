//
// Created by lucas on 10/06/22.
//

#ifndef EDITOR_EDITOR_H
#define EDITOR_EDITOR_H
#include <SFML/Graphics.hpp>
#include "EditorMenu.h"
#include "camera.h"
#include "ConstructionCenter.h"

using namespace sf;

class Editor {
private:
    std::vector<ConstructionCenter*> centers;
    int posX;
    int posY;
    View view;
    View menu_view;
    RenderWindow window;
    Camera* camera;
    Ground* ground;
    bool game_over;
    EditorMenu menu;
    std::vector<std::vector<int>> level;
    std::string name;
    int players;
    void updateCamera();
    bool checkConstruction(int, int);
    void setSprite(int);

public:
    Editor(sf::Vector2i resolution,std::string& name,int x, int y, int players);
    void gameloop();
    ~Editor();
    void setMap(std::vector<std::vector<int>>);
    void setCenters(std::vector<ConstructionCenter *>& center);
};


#endif //EDITOR_EDITOR_H
