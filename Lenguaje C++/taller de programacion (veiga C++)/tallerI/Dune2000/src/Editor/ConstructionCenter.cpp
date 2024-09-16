//
// Created by lucas on 13/06/22.
//

#include "ConstructionCenter.h"

ConstructionCenter::ConstructionCenter(int x, int y): x(x), y(y), selected(false) {
    texture.loadFromFile(ConstantGetter::getResourcePath()+"constructionCenter.png");
    shape.setTexture(&texture);
    shape.setSize(sf::Vector2f(ConstantGetter::getTsize()*3,ConstantGetter::getTsize()*3));
    shape.setPosition(x*ConstantGetter::getTsize(),y*ConstantGetter::getTsize());
}

void ConstructionCenter::render(sf::RenderWindow&target) {
    target.draw(shape);
}

sf::Vector2i ConstructionCenter::getPosition() const {
    return {x,y};
}

ConstructionCenter::ConstructionCenter() {
    texture.loadFromFile(ConstantGetter::getResourcePath()+"constructionCenter.png");
    shape.setTexture(&texture);
    shape.setSize(sf::Vector2f(ConstantGetter::getTsize()*3,ConstantGetter::getTsize()*3));
}

void ConstructionCenter::setPosition(int x , int y ) {
    this->x = x;
    this->y = y;
    shape.setPosition(x*ConstantGetter::getTsize(),y*ConstantGetter::getTsize());
}

void ConstructionCenter::select() {
    texture.loadFromFile(ConstantGetter::getResourcePath()+"constructionCenterS.png");
    shape.setTexture(&texture);
    selected = true;
}

void ConstructionCenter::unSelect() {
    texture.loadFromFile(ConstantGetter::getResourcePath()+"constructionCenter.png");
    shape.setTexture(&texture);
    selected = false;
}

bool ConstructionCenter::isSelected() {
    return selected;
}


