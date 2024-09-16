//
// Created by lucas on 31/05/22.
//

#ifndef VEHICLEIMAGEHANDLER_H
#define VEHICLEIMAGEHANDLER_H

#include "Button.h"
#include "UnitButton.h"
#include "common_protocol.h"

class VehicleImageHandler {
    std::string house;
    UnitButton trike;
    UnitButton sonicTank;
    UnitButton raider;
    UnitButton deviator;
    UnitButton devastator;
    UnitButton tank;
    UnitButton harvester;
    Protocol& protocol;
    void HandleVehiclesActions(sf::Event &event, sf::RenderWindow& window);
    void setVehiclesTextures();
public:
    void displayVehicles(sf::RenderWindow& window);
    void setVehicleMenu();
    void updateVehicles(sf::Event &event, sf::RenderWindow& target);
    void updateTimers();
    explicit VehicleImageHandler(std::string house,Protocol& protocol);
};


#endif
