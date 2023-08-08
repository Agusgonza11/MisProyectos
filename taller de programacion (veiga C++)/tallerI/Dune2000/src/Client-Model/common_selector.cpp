#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>
#include <iostream>
#include "common_selector.h"

using namespace sf;

void Selector::draw(RenderTarget &target, RenderStates states) const {
	target.draw(sprite, states);
}
	
Selector::Selector(){
	texture.loadFromFile("resources/cursores.png");
	sprite.setTexture(texture);
	sprite.setTextureRect(IntRect(0,155,30,27)); 
}
	
void Selector::enable_selection(float x, float y){
	sprite.setPosition(x, y);
}