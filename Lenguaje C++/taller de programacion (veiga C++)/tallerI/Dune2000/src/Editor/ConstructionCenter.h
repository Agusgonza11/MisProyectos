//
// Created by lucas on 13/06/22.
//

#ifndef EDITOR_CONSTRUCTIONCENTER_H
#define EDITOR_CONSTRUCTIONCENTER_H


#include <SFML/Graphics.hpp>
#include "ConstantGetter.h"


class ConstructionCenter {
    int x{};
    int y{};
    sf::RectangleShape shape;
    sf::Texture texture;
    bool selected{};
public:
    ConstructionCenter();
    ConstructionCenter(int x, int y);
    void select();
    void unSelect();
    bool isSelected();
    void setPosition(int,int);
    void render(sf::RenderWindow& target);
    sf::Vector2i getPosition() const;
};


#endif //EDITOR_CONSTRUCTIONCENTER_H
