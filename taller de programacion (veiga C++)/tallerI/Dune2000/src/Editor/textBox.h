//
// Created by lucas on 09/06/22.
//

#ifndef EDITOR_TEXTBOX_H
#define EDITOR_TEXTBOX_H


#include <SFML/Graphics/Transformable.hpp>
#include <SFML/Graphics/Drawable.hpp>
#include <SFML/Graphics/RectangleShape.hpp>
#include <SFML/Window/Event.hpp>

class textBox : public sf::Transformable, public sf::Drawable{
    unsigned int m_size;
    std::string m_text;
    sf::RectangleShape m_rect;
    bool m_hasfocus;
public:
    textBox(unsigned int maxChars);
    const std::string getText() const;
    void setPosition(float x, float y);
    bool contains(sf::Vector2f point) const;
    void setFocus(bool focus);
    void handleInput(sf::Event e);
    virtual void draw(sf::RenderTarget& target, sf::RenderStates states) const;
};




#endif //EDITOR_TEXTBOX_H
