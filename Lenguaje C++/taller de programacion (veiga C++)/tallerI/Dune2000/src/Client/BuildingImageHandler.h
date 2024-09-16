//
// Created by lucas on 31/05/22.
//

#ifndef BUILDINGIMAGEHANDLER_H
#define BUILDINGIMAGEHANDLER_H

#include "Button.h"
#include "UnitButton.h"

class BuildingImageHandler {
    std::string house;
    Button airTrap;
    Button lightFactory;
    Button heavyFactory;
    Button refinery;
    Button silo;
    Button barracks;
    Button palace;
    void HandleBuildingActions(sf::Event &event, sf::RenderWindow& window);
    void setBuildingTextures();
public:
    void displayBuildings(sf::RenderWindow& window);
    void setBuildingMenu();
    void updateBuildings(sf::Event &event, sf::RenderWindow& target);
    explicit BuildingImageHandler(std::string house);
};


#endif
