//
// Created by lucas on 29/05/22.
//

#ifndef CONSTRUCTIONMENU_H
#define CONSTRUCTIONMENU_H

#include "Button.h"
#include "BuildingImageHandler.h"
#include "UnitImageHandler.h"
#include "VehicleImageHandler.h"

enum active{
    BUILDINGS,
    UNITS,
    VEHICLES
};

class ConstructionMenu {
private:
    std::string house;
    Button buildings;
    Button units;
    Button vehicles;

    BuildingImageHandler buildingHandler;
    UnitImageHandler unitHandler;
    VehicleImageHandler vehicleHandler;

    sf::RectangleShape houseImage;
    sf::Texture houseTex;
    void setHouse();
    sf::RectangleShape canvas;
    sf::Texture tx;
    active activeState;
public:
    ConstructionMenu(float x, float y, float width, float height, std::string House);
    void render(sf::RenderWindow& target);
    void update(sf::Event event,sf::RenderWindow& target);
};


#endif CONSTRUCTIONMENU_H
