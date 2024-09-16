//
// Created by lucas on 09/06/22.
//

#include <iostream>
#include "EditorMenu.h"
#include "ConstantGetter.h"
#define BTN_WIDTH 160
#define BTN_HEIGTH 90
#define INITIAL_X 30
#define INITIAL_Y 520
#define DIFERENCE 229
#define DIFERENCE_Y 100


EditorMenu::EditorMenu(float x, float y, float width, float height) {
    std::string path = ConstantGetter::getResourcePath();

    menuTexture.loadFromFile(path + "menuCanvas.png");
    this->canvas.setPosition(sf::Vector2f(x,y));
    this->canvas.setSize(sf::Vector2f(width,height));
    this->canvas.setTexture(&menuTexture);

    sf::Texture texture;
    texture.loadFromFile(path + "sand.bmp");
    this->sand.setTexture(texture);
    this->sand.setPosition(INITIAL_X,INITIAL_Y);
    this->sand.setSize(BTN_WIDTH,BTN_HEIGTH);

    texture.loadFromFile(path + "rocks.bmp");
    this->rocks.setTexture(texture);
    this->rocks.setPosition(INITIAL_X+ DIFERENCE, INITIAL_Y);
    this->rocks.setSize(BTN_WIDTH, BTN_HEIGTH);

    texture.loadFromFile(path + "spice.bmp");
    this->spice.setTexture(texture);
    this->spice.setPosition(INITIAL_X+ DIFERENCE*2, INITIAL_Y);
    this->spice.setSize(BTN_WIDTH, BTN_HEIGTH);

    texture.loadFromFile(path + "saveButton.png");
    this->save.setTexture(texture);
    this->save.setPosition(240, 900);
    this->save.setSize(250, 50);

    texture.loadFromFile(path + "cliffsButton.bmp");
    this->cliff.setTexture(texture);
    this->cliff.setPosition(INITIAL_X, INITIAL_Y + DIFERENCE_Y);
    this->cliff.setSize(BTN_WIDTH, BTN_HEIGTH);

    texture.loadFromFile(path + "topButton.bmp");
    this->top.setTexture(texture);
    this->top.setPosition(INITIAL_X+DIFERENCE, INITIAL_Y + DIFERENCE_Y);
    this->top.setSize(BTN_WIDTH, BTN_HEIGTH);

    texture.loadFromFile(path + "duneButton.bmp");
    this->dune.setTexture(texture);
    this->dune.setPosition(INITIAL_X+DIFERENCE*2, INITIAL_Y + DIFERENCE_Y);
    this->dune.setSize(BTN_WIDTH, BTN_HEIGTH);

    texture.loadFromFile(path + "cyard.gif");
    this->center.setTexture(texture);
    this->center.setPosition(INITIAL_X, INITIAL_Y + DIFERENCE_Y*2);
    this->center.setSize(BTN_WIDTH, BTN_HEIGTH);
}

void EditorMenu::render(sf::RenderWindow &target) {
    target.draw(this->canvas);
    sand.render(target);
    rocks.render(target);
    spice.render(target);
    save.render(target);
    center.render(target);
    cliff.render(target);
    dune.render(target);
    top.render(target);
}


void EditorMenu::update(sf::RenderWindow &target, sf::Event &e, int& selection) {
    this->sand.update(e,target);
    this->rocks.update(e, target);
    this->spice.update(e, target);
    this->save.update(e,target);
    this->center.update(e,target);
    this->cliff.update(e,target);
    this->dune.update(e,target);
    this->top.update(e, target);

    if (sand.is_Clicked(e,target)){
        selection = 0;
    } else if(rocks.is_Clicked(e, target)){
        selection = 1;
    }else if(spice.is_Clicked(e, target)) {
        selection = 2;
    }else if (cliff.is_Clicked(e, target)){
        selection = 3;
    }else if (top.is_Clicked(e, target)){
        selection = 4;
    }else if (dune.is_Clicked(e, target)){
        selection = 5;
    }else if (center.is_Clicked(e, target)){
        selection = -1;
    }

}

bool EditorMenu::checkSaved(sf::RenderWindow &target, sf::Event &e) {
    this->save.update(e,target);
    if (save.is_Clicked(e, target)){
        return true;
    }
    return false;
}


