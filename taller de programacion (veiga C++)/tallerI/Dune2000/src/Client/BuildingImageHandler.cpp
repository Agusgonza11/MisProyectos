//
// Created by lucas on 31/05/22.
//

#include <iostream>
#include "BuildingImageHandler.h"

#define BTN_WIDTH 160
#define BTN_HEIGTH 90
#define INITIAL_X 130
#define INITIAL_Y 520
#define DIFERENCE 180
#define DIFERENCE_Y 100


BuildingImageHandler::BuildingImageHandler(std::string house):house(house){
}

void BuildingImageHandler::setBuildingTextures() {
    sf::Texture texture;
    texture.loadFromFile("../Structures/windtrap.gif");
    this->airTrap.setTexture(texture);

    texture.loadFromFile("../Structures/hfactory.gif");
    this->heavyFactory.setTexture(texture);

    texture.loadFromFile("../Structures/lfactory.gif");
    this->lightFactory.setTexture(texture);

    texture.loadFromFile("../Structures/opalace.gif");
    this->palace.setTexture(texture);

    texture.loadFromFile("../Structures/refinery.gif");
    this->refinery.setTexture(texture);

    texture.loadFromFile("../Structures/silo.gif");
    this->silo.setTexture(texture);

    if (house == "Atreides"){
        texture.loadFromFile("../Structures/abarracks.jpg");
        this->barracks.setTexture(texture);
    }
    if (house == "Harkonnen"){
        texture.loadFromFile("../Structures/hbarracks.jpg");
        this->barracks.setTexture(texture);
    }
    if (house == "Ordos"){
        texture.loadFromFile("../Structures/obarracks.jpg");
        this->barracks.setTexture(texture);
    }
}


void BuildingImageHandler::setBuildingMenu() {
    this->airTrap.setSize(BTN_WIDTH,BTN_HEIGTH);
    this->heavyFactory.setSize(BTN_WIDTH,BTN_HEIGTH);
    this->barracks.setSize(BTN_WIDTH,BTN_HEIGTH);
    this->lightFactory.setSize(BTN_WIDTH,BTN_HEIGTH);
    this->palace.setSize(BTN_WIDTH,BTN_HEIGTH);
    this->refinery.setSize(BTN_WIDTH,BTN_HEIGTH);
    this->silo.setSize(BTN_WIDTH,BTN_HEIGTH);

    this->airTrap.setPosition(INITIAL_X,INITIAL_Y);
    this->barracks.setPosition(INITIAL_X+DIFERENCE, INITIAL_Y);
    this->lightFactory.setPosition(INITIAL_X + 2*DIFERENCE, INITIAL_Y);
    this->refinery.setPosition(INITIAL_X,INITIAL_Y+DIFERENCE_Y);
    this->silo.setPosition(INITIAL_X + DIFERENCE,INITIAL_Y + DIFERENCE_Y);
    this->heavyFactory.setPosition(INITIAL_X + DIFERENCE * 2,INITIAL_Y + DIFERENCE_Y);
    this->palace.setPosition(INITIAL_X, INITIAL_Y+ DIFERENCE_Y * 2);

    setBuildingTextures();
}

void BuildingImageHandler::displayBuildings(sf::RenderWindow& target) {
    this->airTrap.render(target);
    this->heavyFactory.render(target);
    this->barracks.render(target);
    this->lightFactory.render(target);
    this->palace.render(target);
    this->refinery.render(target);
    this->silo.render(target);
}


void BuildingImageHandler::updateBuildings(sf::Event &event, sf::RenderWindow& target) {
    this->airTrap.update(event,target);
    this->heavyFactory.update(event,target);
    this->barracks.update(event,target);
    this->lightFactory.update(event, target);
    this->palace.update(event,target);
    this->refinery.update(event, target);
    this->silo.update(event, target);
    HandleBuildingActions(event, target);
}

void BuildingImageHandler::HandleBuildingActions(sf::Event &event, sf::RenderWindow &window) {
    if (airTrap.is_Clicked(event,window)){
        std::cout<<"Se construye air trap \n";
    } else if (heavyFactory.is_Clicked(event,window)){
        std::cout<<"Se construye heavy factory \n";
    } else if (lightFactory.is_Clicked(event,window)){
        std::cout<<"Se construye light factory \n";
    } else if (barracks.is_Clicked(event,window)){
        std::cout<<"Se construye barracks \n";
    } else if (silo.is_Clicked(event,window)){
        std::cout<<"Se construye silo \n";
    } else if (palace.is_Clicked(event,window)){
        std::cout<<"Se construye palace \n";
    } else if (refinery.is_Clicked(event,window)){
        std::cout<<"Se construye refinery \n";
    }

}


