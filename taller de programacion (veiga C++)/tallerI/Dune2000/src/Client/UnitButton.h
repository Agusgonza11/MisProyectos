//
// Created by lucas on 18/06/22.
//

#ifndef CLIENT_UNITBUTTON_H
#define CLIENT_UNITBUTTON_H
#include "Button.h"

class UnitButton: public Button{
private:
    sf::Font font;
    sf::Text timerText;
    sf::Text timesPressedText;
    int timesPressed;
    sf::Clock clock;
    int countdown;
    int timeElapse;
public:
    void update(sf::Event& e, sf::RenderWindow& window);
    void render(sf::RenderWindow& target);
    bool is_Clicked (sf::Event& e, sf::RenderWindow& window);
    void updateTimer();
    UnitButton();
};


#endif //CLIENT_UNITBUTTON_H
