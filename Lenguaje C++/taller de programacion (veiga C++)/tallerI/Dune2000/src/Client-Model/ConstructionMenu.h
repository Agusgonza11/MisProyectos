//
// Created by lucas on 29/05/22.
//

#ifndef CONSTRUCTIONMENU_H
#define CONSTRUCTIONMENU_H

#include "Button.h"
#include "UnitImageHandler.h"
#include "VehicleImageHandler.h"
#include "common_protocol.h"

enum active{
    UNITS,
    VEHICLES
};

class ConstructionMenu {
private:
    std::string house;
    Button units;
    Button vehicles;

    UnitImageHandler unitHandler;
    VehicleImageHandler vehicleHandler;

    sf::RectangleShape houseImage;
    sf::Texture houseTex;
    void setHouse();
    sf::RectangleShape canvas;
    sf::Texture tx;
    active activeState;
public:
    ConstructionMenu(float x, float y, float width, float height, std::string House, Protocol& aProtocol);
    void render(sf::RenderWindow& target);
    void update(sf::Event event,sf::RenderWindow& target);
};


#endif
