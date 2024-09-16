//
// Created by lucas on 31/05/22.
//

#include "VehicleImageHandler.h"

#define BTN_WIDTH 160
#define BTN_HEIGTH 90
#define INITIAL_X 130
#define INITIAL_Y 520
#define DIFERENCE 180
#define DIFERENCE_Y 100

VehicleImageHandler::VehicleImageHandler(std::string house): house(house) {
}

void VehicleImageHandler::setVehicleMenu() {
    this->tank.setSize(BTN_WIDTH,BTN_HEIGTH);
    this->harvester.setSize(BTN_WIDTH,BTN_HEIGTH);

    if (house == "Atreides" || house == "Harkonnen"){
        this->trike.setSize(BTN_WIDTH,BTN_HEIGTH);
        this->trike.setPosition(INITIAL_X,INITIAL_Y);
    }
    if (house == "Atreides"){
        this->sonicTank.setSize(BTN_WIDTH,BTN_HEIGTH);
        this->sonicTank.setPosition(INITIAL_X+DIFERENCE, INITIAL_Y);
        this->tank.setPosition(INITIAL_X + DIFERENCE * 2,INITIAL_Y);
        this->harvester.setPosition(INITIAL_X, INITIAL_Y+ DIFERENCE_Y);
    }
    if (house == "Ordos"){
        this->raider.setSize(BTN_WIDTH,BTN_HEIGTH);
        this->deviator.setSize(BTN_WIDTH,BTN_HEIGTH);
        this->raider.setPosition(INITIAL_X, INITIAL_Y);
        this->deviator.setPosition(INITIAL_X + DIFERENCE,INITIAL_Y);
        this->tank.setPosition(INITIAL_X + DIFERENCE * 2,INITIAL_Y);
        this->harvester.setPosition(INITIAL_X, INITIAL_Y+ DIFERENCE_Y);
    }
    if (house == "Harkonnen"){
        this->devastator.setSize(BTN_WIDTH,BTN_HEIGTH);
        this->devastator.setPosition(INITIAL_X + DIFERENCE,INITIAL_Y);
        this->tank.setPosition(INITIAL_X + DIFERENCE * 2,INITIAL_Y);
        this->harvester.setPosition(INITIAL_X, INITIAL_Y+ DIFERENCE_Y);
    }

    setVehiclesTextures();
}

void VehicleImageHandler::setVehiclesTextures() {
    sf::Texture texture;

    texture.loadFromFile("../Structures/tank.jpg");
    this->tank.setTexture(texture);

    texture.loadFromFile("../Structures/harvest.jpg");
    this->harvester.setTexture(texture);

    if (house == "Atreides" || house == "Harkonnen"){
        texture.loadFromFile("../Structures/trike.png");
        this->trike.setTexture(texture);
    }
    if (house == "Atreides"){
        texture.loadFromFile("../Structures/sonic.jpg");
        this->sonicTank.setTexture(texture);
    }
    if (house == "Ordos"){
        texture.loadFromFile("../Structures/raider.jpg");
        this->raider.setTexture(texture);
        texture.loadFromFile("../Structures/deviator.jpg");
        this->deviator.setTexture(texture);
    }
    if (house == "Harkonnen"){
        texture.loadFromFile("../Structures/devast.jpg");
        this->devastator.setTexture(texture);
    }
}

void VehicleImageHandler::displayVehicles(sf::RenderWindow &window) {
    this->tank.render(window);

    this->harvester.render(window);

    if (house == "Atreides" || house == "Harkonnen"){
        this->trike.render(window);
    }
    if (house == "Atreides"){
        this->sonicTank.render(window);
    }
    if (house == "Ordos"){
        this->raider.render(window);
        this->deviator.render(window);
    }
    if (house == "Harkonnen"){
        this->devastator.render(window);
    }
}

void VehicleImageHandler::updateVehicles(sf::Event &event, sf::RenderWindow &target) {
    this->tank.update(event,target);

    this->harvester.update(event,target);

    if (house == "Atreides" || house == "Harkonnen"){
        this->trike.update(event, target);
    }
    if (house == "Atreides"){
        this->sonicTank.update(event,target);
    }
    if (house == "Ordos"){
        this->raider.update(event, target);
        this->deviator.update(event, target);
    }
    if (house == "Harkonnen"){
        this->devastator.update(event, target);
    }
    HandleVehiclesActions(event, target);
}

void VehicleImageHandler::HandleVehiclesActions(sf::Event &event, sf::RenderWindow &window) {
    if (tank.is_Clicked(event, window)){

    }else if (trike.is_Clicked(event,window)){

    }else if (sonicTank.is_Clicked(event,window)){

    }else if (raider.is_Clicked(event, window)){

    }else if (devastator.is_Clicked(event, window)){

    }else if (deviator.is_Clicked(event,window)){

    }else if (harvester.is_Clicked(event, window)){

    }
}

void VehicleImageHandler::updateTimers() {
    tank.updateTimer();
    trike.updateTimer();
    sonicTank.updateTimer();
    raider.updateTimer();
    devastator.updateTimer();
    deviator.updateTimer();
    harvester.updateTimer();
}
