//
// Created by lucas on 29/05/22.
//

#include <iostream>
#include "ConstructionMenu.h"

#define BTN_WIDTH 160
#define BTN_HEIGTH 90
#define INITIAL_X 130
#define INITIAL_Y 520
#define DIFERENCE 180
#define DIFERENCE_Y 100


ConstructionMenu::ConstructionMenu(float x, float y, float width, float height, std::string house): buildingHandler(house),
                                                                                                    unitHandler(house),
                                                                                                    vehicleHandler(house){
    this->house = house;
    tx.loadFromFile("/home/lucas/Desktop/menuCanvas.png");
    this->canvas.setPosition(sf::Vector2f(x,y));
    this->canvas.setSize(sf::Vector2f(width,height));
    this->canvas.setTexture(&tx);

    setHouse();

    buildingHandler.setBuildingMenu();
    unitHandler.setUnitMenu();
    vehicleHandler.setVehicleMenu();

    buildings.setPosition(20,520);
    buildings.setSize(70,45);
    sf::Texture build;
    build.loadFromFile("../Structures/buildings.png");
    buildings.setTexture(build);

    units.setPosition(20,578);
    units.setSize(70,45);
    sf::Texture unit;
    unit.loadFromFile("../Structures/units.png");
    units.setTexture(unit);

    vehicles.setPosition(20,636);
    vehicles.setSize(70,45);
    sf::Texture vehicle;
    vehicle.loadFromFile("../Structures/vehicles.png");
    vehicles.setTexture(vehicle);

    activeState = BUILDINGS;
}

void ConstructionMenu::setHouse() {
    this->houseImage.setSize(sf::Vector2f(500,300));
    this->houseImage.setPosition(100,100);
    if (house == "Atreides"){
        houseTex.loadFromFile("../Structures/EBFD_Atreides_Logo.png");
        this->houseImage.setTexture(&houseTex);
    }
    if (house == "Harkonnen"){
        houseTex.loadFromFile("../Structures/EBFD_Harkonnen_Logo.png");
        this->houseImage.setTexture(&houseTex);
    }
    if (house == "Ordos"){
        houseTex.loadFromFile("../Structures/EBFD_Ordos_Logo.png");
        this->houseImage.setTexture(&houseTex);
    }
}



void ConstructionMenu::render(sf::RenderWindow& target) {
    target.draw(this->canvas);
    target.draw(this->houseImage);
    buildings.render(target);
    units.render(target);
    vehicles.render(target);
    vehicleHandler.updateTimers();
    unitHandler.updateTimers();

    if (activeState == BUILDINGS) {
        buildingHandler.displayBuildings(target);
    }else if(activeState == UNITS){
        unitHandler.displayUnits(target);
    }else if (activeState == VEHICLES){
        vehicleHandler.displayVehicles(target);
    }
}


void ConstructionMenu::update(sf::Event event, sf::RenderWindow &target) {
    buildings.update(event,target);
    units.update(event,target);
    vehicles.update(event,target);


    if (buildings.is_Clicked(event,target)){
        activeState = BUILDINGS;
    }

    if (units.is_Clicked(event,target)){
        activeState = UNITS;
    }

    if (vehicles.is_Clicked(event,target)){
        activeState = VEHICLES;
    }

    if (activeState == UNITS){
        unitHandler.updateUnits(event,target);
    }

    if (activeState == BUILDINGS){
        buildingHandler.updateBuildings(event,target);
    }

    if (activeState == VEHICLES){
        vehicleHandler.updateVehicles(event, target);
    }

}



