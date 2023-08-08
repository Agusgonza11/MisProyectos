//
// Created by lucas on 18/06/22.
//

#include <iostream>
#include "UnitButton.h"

UnitButton::UnitButton() {
    timesPressed = 0;
    font.loadFromFile("resources/Dune_Rise.ttf");
    timesPressedText.setFont(font);
    timerText.setFont(font);
    countdown = 5;
    timeElapse = 0;
}

void UnitButton::update(sf::Event &e, sf::RenderWindow &window) {
    Button::update(e, window);
    timesPressedText.setString(std::to_string(timesPressed));
    timesPressedText.setPosition(this->shape.getPosition());
    timerText.setString(std::to_string(countdown));
    timerText.setPosition(this->shape.getPosition().x+60,this->shape.getPosition().y+20);

}

void UnitButton::render(sf::RenderWindow &target) {
    Button::render(target);
    if (timesPressed>0) {
        target.draw(timesPressedText);
        target.draw(timerText);
    }

}

bool UnitButton::is_Clicked(sf::Event &e, sf::RenderWindow &window) {
    bool result = Button::is_Clicked(e, window);
    if (result){
        timesPressed++;
    }
    return result;

}

void UnitButton::updateTimer() {
    int timer = clock.getElapsedTime().asSeconds();
    if (timesPressed>0) {
        timerText.setString(std::to_string(countdown));
        timesPressedText.setString(std::to_string(timesPressed));
        if (timer > 0 && timer != timeElapse) {
            countdown--;
            timeElapse = timer;
        }
        if (countdown <= 0 && timesPressed != 0) {
            timesPressed--;
            if (countdown == 0) {
                countdown = 5;
            }
        }
    }
}
