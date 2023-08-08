#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "common_unit.h"
#include "common_infantery.h"


Trike::Trike(int cordX, int cordY, int id): Unit(cordX, cordY, id) {
	texture.loadFromFile("trike.png");
	sprite.setTexture(texture);
	sprite.setTextureRect(IntRect(5,60,30,30));
	sprite.setPosition(x, y);
	this->velocity = 0.1;
	this->largeBitsX = 30;
	this->largeBitsY = 30;
	this->actualFrame = 17;
	fillFrames();
}


void Trike::modifyMovePosition(bool moveRight, bool moveLeft, bool moveUp, bool moveDown){
	int frameDestiny;
	if(moveRight){
		if(moveUp) frameDestiny = 5;
		if(moveDown) frameDestiny = 13;
		else if(!moveUp && !moveDown) frameDestiny = 9;		
	}
	if(moveLeft){
		if(moveUp) frameDestiny = 29;
		if(moveDown) frameDestiny = 21;
		else if(!moveUp && !moveDown) frameDestiny = 25;
	}
	if(!moveRight && !moveLeft && !moveUp && moveDown) frameDestiny = 17;
	if(!moveRight && !moveLeft && moveUp && !moveDown) frameDestiny = 1;
	if(frameActual > frameDestiny){
		actualFrame--;
	}
	if(frameActual < frameDestiny){
		actualFrame++;
	}	
	Vector2f &posicionFrame = frames[actualFrame];	
	sprite.setTextureRect(IntRect(posicionFrame.x, posicionFrame.y,30,25));
	}
	


void Trike::fillFrames(){
	frames.insert(std::pair<int,Vector2f>(1, Vector2f(5,5)));
	frames.insert(std::pair<int,Vector2f>(2, Vector2f(40,5)));
	frames.insert(std::pair<int,Vector2f>(3, Vector2f(75,5)));
	frames.insert(std::pair<int,Vector2f>(4, Vector2f(110,5)));
	frames.insert(std::pair<int,Vector2f>(5, Vector2f(140,5)));
	frames.insert(std::pair<int,Vector2f>(6, Vector2f(175,5)));
	frames.insert(std::pair<int,Vector2f>(7, Vector2f(200,5)));
	frames.insert(std::pair<int,Vector2f>(8, Vector2f(235,5)));	
	frames.insert(std::pair<int,Vector2f>(9, Vector2f(5,35)));
	frames.insert(std::pair<int,Vector2f>(10, Vector2f(40,35)));
	frames.insert(std::pair<int,Vector2f>(11, Vector2f(75,35)));
	frames.insert(std::pair<int,Vector2f>(12, Vector2f(110,35)));
	frames.insert(std::pair<int,Vector2f>(13, Vector2f(140,35)));
	frames.insert(std::pair<int,Vector2f>(14, Vector2f(175,35)));
	frames.insert(std::pair<int,Vector2f>(15, Vector2f(200,35)));
	frames.insert(std::pair<int,Vector2f>(16, Vector2f(235,35)));
	frames.insert(std::pair<int,Vector2f>(17, Vector2f(5,60)));
	frames.insert(std::pair<int,Vector2f>(18, Vector2f(40,60)));
	frames.insert(std::pair<int,Vector2f>(19, Vector2f(75,60)));
	frames.insert(std::pair<int,Vector2f>(20, Vector2f(110,60)));
	frames.insert(std::pair<int,Vector2f>(21, Vector2f(140,60)));
	frames.insert(std::pair<int,Vector2f>(22, Vector2f(175,60)));
	frames.insert(std::pair<int,Vector2f>(23, Vector2f(200,60)));
	frames.insert(std::pair<int,Vector2f>(24, Vector2f(235,60)));
	frames.insert(std::pair<int,Vector2f>(25, Vector2f(5,85)));
	frames.insert(std::pair<int,Vector2f>(26, Vector2f(40,60)));
	frames.insert(std::pair<int,Vector2f>(27, Vector2f(75,60)));
	frames.insert(std::pair<int,Vector2f>(28, Vector2f(110,60)));
	frames.insert(std::pair<int,Vector2f>(29, Vector2f(140,85)));
	frames.insert(std::pair<int,Vector2f>(30, Vector2f(175,85)));
	frames.insert(std::pair<int,Vector2f>(31, Vector2f(200,85)));
	frames.insert(std::pair<int,Vector2f>(32, Vector2f(235,85)));
}


