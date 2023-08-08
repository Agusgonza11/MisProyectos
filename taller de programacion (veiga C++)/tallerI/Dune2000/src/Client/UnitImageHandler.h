//
// Created by lucas on 31/05/22.
//

#ifndef UNITIMAGEHANDLER_H
#define UNITIMAGEHANDLER_H

#include "Button.h"
#include "UnitButton.h"

class UnitImageHandler {
    std::string house;
    UnitButton lightInfantry;
    UnitButton heavyInfantry;
    UnitButton fremen;
    UnitButton sardukar;
    void setUnitTextures();
    void handleUnitActions(sf::Event &event, sf::RenderWindow& target);
public:
    void setUnitMenu();
    void displayUnits(sf::RenderWindow& window);
    void updateUnits(sf::Event &event, sf::RenderWindow& target);
    explicit UnitImageHandler(std::string house);
    void updateTimers();
};


#endif
