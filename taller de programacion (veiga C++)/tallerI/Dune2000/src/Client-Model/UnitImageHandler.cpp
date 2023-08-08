//
// Created by lucas on 31/05/22.
//

#include "UnitImageHandler.h"

#define BTN_WIDTH 160
#define BTN_HEIGTH 90
#define INITIAL_X 130
#define INITIAL_Y 520
#define DIFERENCE 180
#define DIFERENCE_Y 100


UnitImageHandler::UnitImageHandler(std::string house): house(house) {
}

void UnitImageHandler::setUnitMenu() {
    this->lightInfantry.setSize(BTN_WIDTH,BTN_HEIGTH);
    this->heavyInfantry.setSize(BTN_WIDTH,BTN_HEIGTH);

    this->lightInfantry.setPosition(INITIAL_X,INITIAL_Y);
    this->heavyInfantry.setPosition(INITIAL_X+DIFERENCE, INITIAL_Y);

    if (house=="Atreides"){
        this->fremen.setSize(BTN_WIDTH,BTN_HEIGTH);
        this->fremen.setPosition(INITIAL_X + 2*DIFERENCE, INITIAL_Y);
    }else if (house == "Harkonnen"){
        this->sardukar.setSize(BTN_WIDTH,BTN_HEIGTH);
        this->sardukar.setPosition(INITIAL_X + 2*DIFERENCE, INITIAL_Y);
    }
    setUnitTextures();
}

void UnitImageHandler::setUnitTextures() {
    sf::Texture texture;
    texture.loadFromFile("Structures/linfantry.gif");
    lightInfantry.setTexture(texture);

    texture.loadFromFile("Structures/hinfantry.gif");
    heavyInfantry.setTexture(texture);

    if (house=="Atreides"){
        texture.loadFromFile("Structures/fremen.gif");
        fremen.setTexture(texture);
    }else if (house == "Harkonnen"){
        texture.loadFromFile("Structures/sardukar.gif");
        sardukar.setTexture(texture);
    }
}


void UnitImageHandler::displayUnits(sf::RenderWindow& target) {
    this->lightInfantry.render(target);
    this->heavyInfantry.render(target);

    if (house == "Atreides"){
        this->fremen.render(target);
    }else if (house == "Harkonnen"){
        this->sardukar.render(target);
    }

}

void UnitImageHandler::updateUnits(sf::Event &event, sf::RenderWindow &target) {
    this->lightInfantry.update(event,target);
    this->heavyInfantry.update(event,target);

    if (house == "Atreides"){
        this->fremen.update(event,target);
    }else if (house == "Harkonnen"){
        this->sardukar.update(event,target);
    }
    handleUnitActions(event, target);
}

void UnitImageHandler::handleUnitActions(sf::Event &event, sf::RenderWindow& target) {
    if (lightInfantry.is_Clicked(event,target)){

    }else if (heavyInfantry.is_Clicked(event,target)){

    }else if (fremen.is_Clicked(event,target)){

    }else if (sardukar.is_Clicked(event,target)){

    }
}

void UnitImageHandler::updateTimers() {
    lightInfantry.updateTimer();
    heavyInfantry.updateTimer();
    fremen.updateTimer();
    sardukar.updateTimer();
}

