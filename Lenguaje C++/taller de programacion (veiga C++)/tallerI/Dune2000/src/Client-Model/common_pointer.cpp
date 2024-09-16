#include <iostream>
#include <string>
#include <fstream>
#include <arpa/inet.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <cstring>
#include <tuple>
#include "client_class.h"
#include <vector>
#include <sstream>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "common_protocol.h"
//#include "common_socket.h"
#include "common_pointer.h"

using namespace sf;

Pointer::Pointer(RenderWindow &window, int team){
	fillFrames();
	this->frame = 0;
	this->is_enemy = false;
	this->team = team;
	window.setMouseCursorVisible(false);
	texture.loadFromFile("resources/cursores.png");
	sprite.setTexture(texture);
	sprite.setTextureRect(IntRect(0,0,15,15)); 
}
void Pointer::unit_move_mode(){
	this->frame = 1;
}
	
void Pointer::normal_mode(){
	sprite.setTextureRect(IntRect(0,0,15,15));
	this->frame = 0;
}

	
void Pointer::updateTexture(){
	if(is_enemy){
		if(frame > 8) frame++;
		if(frame < 8 || frame == 16) frame = 9;
	} else {
		if(frame < 8) frame++;
		if(frame >= 8) frame = 1;
	}
	Vector2f &posicionFrame = frames[frame];
	sprite.setTextureRect(IntRect(posicionFrame.x, posicionFrame.y,30,27));
}

void Pointer::update(Vector2i &posicion, int posX, int posY, RenderWindow &window, std::map <int, Unit*> &units){
    sf::Vector2f mousePosition = window.mapPixelToCoords(posicion);
	for(auto iter = units.begin(); iter != units.end(); ++iter){
		if(iter->second->get_team() != team){
			if(iter->second->is_there(posicion.x + posX, posicion.y + posY)){
				is_enemy = true;
				break;
			} else { 
				is_enemy = false;
			}
		} else {
			is_enemy = false;
		}
	}
    sprite.setPosition(mousePosition.x - 15, mousePosition.y - 15);
	//sprite.setPosition(posicion.x + posX - 15, posicion.y + posY - 15);
	if(frame != 0) updateTexture();
	window.draw(sprite);
}
	
void Pointer::fillFrames(){
	frames.insert(std::pair<int,Vector2f>(1, Vector2f(0,15)));
	frames.insert(std::pair<int,Vector2f>(2, Vector2f(35,15)));
	frames.insert(std::pair<int,Vector2f>(3, Vector2f(70,15)));
	frames.insert(std::pair<int,Vector2f>(4, Vector2f(100,15)));
	frames.insert(std::pair<int,Vector2f>(5, Vector2f(135,15)));
	frames.insert(std::pair<int,Vector2f>(6, Vector2f(168,15)));
	frames.insert(std::pair<int,Vector2f>(7, Vector2f(200,15)));
	frames.insert(std::pair<int,Vector2f>(8, Vector2f(233,15)));	
	frames.insert(std::pair<int,Vector2f>(9, Vector2f(0,70)));	
	frames.insert(std::pair<int,Vector2f>(10, Vector2f(30,70)));
	frames.insert(std::pair<int,Vector2f>(11, Vector2f(65,70)));		
	frames.insert(std::pair<int,Vector2f>(12, Vector2f(95,70)));		
	frames.insert(std::pair<int,Vector2f>(13, Vector2f(125,70)));		
	frames.insert(std::pair<int,Vector2f>(14, Vector2f(157,70)));		
	frames.insert(std::pair<int,Vector2f>(15, Vector2f(187,70)));		
	frames.insert(std::pair<int,Vector2f>(16, Vector2f(220,70)));	
}

void Pointer::render(RenderWindow &window) {
    sf::Vector2i WinPos = sf::Mouse::getPosition(window);
    sf::Vector2f mousePosition = window.mapPixelToCoords(WinPos);
    sprite.setPosition(mousePosition.x, mousePosition.y);
    sprite.setScale(Vector2f(1.0f,1.0f));
    window.draw(this->sprite);
}