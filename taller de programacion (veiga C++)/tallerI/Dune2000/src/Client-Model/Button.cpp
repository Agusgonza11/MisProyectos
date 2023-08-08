//
// Created by lucas on 28/05/22.
//

#include <iostream>
#include "Button.h"


Button::Button(float x, float y, float width, float height, sf::Texture tx){
    texture = tx;
    this->shape.setPosition(sf::Vector2f(x,y));
    this->shape.setSize(sf::Vector2f(width,height));
    this->shape.setTexture(&texture);
    shape.setFillColor(sf::Color(255,235,255,200));
}

void Button::setTexture(sf::Texture tx) {
    texture = tx;
    shape.setTexture(&texture);
}

void Button::setPosition(float x, float y) {
    this->shape.setPosition(x,y);
}

void Button::setSize(float width, float height) {
    this->shape.setSize(sf::Vector2f (width,height));
}

void Button::render(sf::RenderWindow& target) {
    target.draw(this->shape);
}

void Button::update(sf::Event& e, sf::RenderWindow& window) {
    state = BTN_IDLE;
    sf::Vector2i WinPos = sf::Mouse::getPosition(window);
    sf::Vector2f mousePosition = window.mapPixelToCoords(WinPos);

    bool mouseInButton = shape.getGlobalBounds().contains(mousePosition);

    if (e.type == sf::Event::MouseMoved){
        if (mouseInButton){
            state = BTN_HOVERED;
        } else{
            state = BTN_IDLE;
        }
    }
    if (e.type == sf::Event::MouseButtonPressed){
        if (mouseInButton) {
            if (e.mouseButton.button == sf::Mouse::Left) {
                state = BTN_PRESSED;
            } else {
                state = BTN_IDLE;
            }
        }
    }
    this->buttonAction();

}

void Button::buttonAction() {
    switch (state) {
        case BTN_HOVERED:
            shape.setFillColor(sf::Color(255,255,255,255));
            break;
        case BTN_IDLE:
            shape.setFillColor(sf::Color(255,235,255,200));
            break;
        case BTN_PRESSED:
            shape.setFillColor(sf::Color(255,255,255,120));
            break;
        case BTN_CLICKED:
            break;
    }
}

bool Button::is_Clicked (sf::Event& e, sf::RenderWindow& window){
    sf::Vector2i WinPos = sf::Mouse::getPosition(window);
    sf::Vector2f mousePosition = window.mapPixelToCoords(WinPos);

    bool mouseInButton = shape.getGlobalBounds().contains(mousePosition);
    if (e.type == sf::Event::MouseButtonReleased){
        if (mouseInButton && e.mouseButton.button == sf::Mouse::Left){
            return true;
        }else{
            return false;
        }
    } else{
        return false;
    }
}

Button::~Button(){}


