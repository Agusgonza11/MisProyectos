//
// Created by lucas on 09/06/22.
//

#ifndef EDITOR_EDITORMENU_H
#define EDITOR_EDITORMENU_H

#include "Button.h"

class EditorMenu {
    sf::Texture menuTexture;
    sf::RectangleShape canvas;
    Button sand;
    Button spice;
    Button rocks;
    Button save;
    Button cliff;
    Button top;
    Button dune;
    Button center;

public:
    EditorMenu(float x, float y, float height, float width);
    void update(sf::RenderWindow& target, sf::Event& e, int& selection);
    void render(sf::RenderWindow& target);
    bool checkSaved(sf::RenderWindow& target, sf::Event& e);

};


#endif //EDITOR_EDITORMENU_H
