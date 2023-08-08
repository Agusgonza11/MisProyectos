//
// Created by lucas on 28/05/22.
//

#ifndef BUTTON_H
#define BUTTON_H

#include <SFML/Graphics.hpp>

enum button_states{BTN_CLICKED, BTN_IDLE, BTN_PRESSED, BTN_HOVERED};

class Button {
protected:
    button_states state;
    sf::Texture texture;
    sf::RectangleShape shape;
public:
    Button(float x, float y, float width, float height, sf::Texture);
    Button() = default;
    ~Button();
    void setPosition(float x, float y);
    void setSize(float width, float height);
    void setTexture(sf::Texture tx);
    void render(sf::RenderWindow& target);
    void update(sf::Event& e, sf::RenderWindow& window);
    bool is_Clicked (sf::Event& e, sf::RenderWindow& window);
    void buttonAction();
};


#endif
