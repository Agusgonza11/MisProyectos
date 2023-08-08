#include <vector>
#include <iostream>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <SFML/Audio.hpp>
#include <time.h>
#include "common_explosion.h"


using namespace sf;

	
Explosion::Explosion(float x, float y){
	image.loadFromFile("resources/explosion/1.bmp");
	image.createMaskFromColor(sf::Color::Black);
	texture.loadFromImage(image);
	sprite.setTexture(texture);
	sprite.setPosition(x,y);
	buffer.loadFromFile("resources/explosion/1.wav");
	sound.setBuffer(buffer);
	sound.setVolume(2);
	this->frame = 1;
	this->x = x;
	this->y = y;
	is_finish = false;
	cont = 0;
}

void Explosion::draw(RenderTarget &target, RenderStates states) const {
	target.draw(sprite, states);
}
	
bool Explosion::finish(){
	return is_finish;
}

void Explosion::animateExplosion(){
	if(frame == 1) sound.play();
	if(cont % 20 == 0) updateTexture();
	cont++;
}
	
void Explosion::updateTexture(){
	std::string f = "resources/explosion/" + std::to_string(frame) + ".bmp";
	image.loadFromFile(f);
	image.createMaskFromColor(sf::Color::Black);	
	texture.loadFromImage(image);
	Vector2u size = texture.getSize();
	sprite.setTexture(texture);
	sprite.setTextureRect(IntRect(0,0,size.x,size.y));
	frame++;
	if(frame == 17) is_finish = true;
}
	
std::tuple<int, int, int, int> Explosion::get_bits(){
	return std::make_tuple(x, y, 60, 60);
}