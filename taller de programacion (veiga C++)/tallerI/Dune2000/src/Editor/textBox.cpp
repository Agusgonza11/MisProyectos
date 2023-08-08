//
// Created by lucas on 09/06/22.
//

#include "textBox.h"
#include <SFML/Graphics.hpp>

textBox::textBox(unsigned int maxChars) :m_size(maxChars),
                                                   m_rect(sf::Vector2f(15 * m_size, 20)),
                                                   m_hasfocus(false){

    m_rect.setOutlineThickness(2);
    m_rect.setFillColor(sf::Color::White);
    m_rect.setOutlineColor(sf::Color(255,255,255));
    m_rect.setPosition(this->getPosition());
    sf::Text xd;

}

const std::string textBox::getText() const {
    return m_text;
}

void textBox::setPosition(float x, float y) {
    Transformable::setPosition(x, y);
    m_rect.setPosition(x, y);
}

bool textBox::contains(sf::Vector2f point) const {
    return m_rect.getGlobalBounds().contains(point);
}

void textBox::setFocus(bool focus){
    m_hasfocus = focus;
    if (focus){
        m_rect.setOutlineColor(sf::Color::Blue);
    }
    else {
        m_rect.setOutlineColor(sf::Color(255, 255, 255));
    }
}

void textBox::handleInput(sf::Event e){
    if (!m_hasfocus || e.type != sf::Event::TextEntered)
        return;

    if (e.text.unicode == 8){   // Delete key
        m_text = m_text.substr(0, m_text.size() - 1);
    }
    else if (m_text.size() < m_size){
        m_text += e.text.unicode;
    }
}

void textBox::draw(sf::RenderTarget &target, sf::RenderStates states) const {
    target.draw(m_rect, states);
}
