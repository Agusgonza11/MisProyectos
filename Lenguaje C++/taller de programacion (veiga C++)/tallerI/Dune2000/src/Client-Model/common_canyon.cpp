#include <vector>
#include <iostream>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <SFML/Audio.hpp>
#include <time.h>
#include "common_canyon.h"


using namespace sf;

Canyon::Canyon(std::map <int, Vector2f> &frames): frames(frames){
	image.loadFromFile("resources/Shoot.png");
	image.createMaskFromColor(sf::Color::White);
	Color gray = image.getPixel(25,5);
	image.createMaskFromColor(gray);
	texture.loadFromImage(image);
	sprite.setTexture(texture);
	sprite.setScale(Vector2f(0.3,0.3));
	cont = 1;
	buffer.loadFromFile("resources/sounds/attacks/shoot.wav");
	attackSound.setBuffer(buffer);
	attackSound.setVolume(2);
	actualFrame = 1;
}


void Canyon::canyonPosition(float posX, float posY, int frame){
	switch(frame){
		case 36:
			sprite.setPosition(posX + 10, posY - 12);
			break;
		case 46:
			sprite.setPosition(posX + 10, posY + 10);
			break;
		case 41:
			sprite.setPosition(posX + 15, posY - 5);
			break;
		case 61:
			sprite.setPosition(posX - 10, posY - 12);
			break;
		case 53:
			sprite.setPosition(posX - 10, posY + 10);
			break;
		case 57:
			sprite.setPosition(posX - 10, posY - 4);
			break;
		case 49:
			sprite.setPosition(posX, posY + 12);
			break;
		case 33:
			sprite.setPosition(posX, posY - 15);
			break;	
	}
}


void Canyon::updateTexture(){
	Vector2f &posicionFrameCanion = frames[actualFrame];
	sprite.setTextureRect(IntRect(posicionFrameCanion.x, posicionFrameCanion.y,125,125));
	actualFrame++;
	if(actualFrame == 26) actualFrame = 1;
}

void Canyon::animate(float posX, float posY, bool is_attacking, int frame){
	bool is_drawable = false;
	if(is_attacking){
		if(cont % 100 == 0){
			attackSound.play();
			is_drawable = true;
		} else {
			sprite.setPosition(-1000, -1000);
			is_drawable = false;
		}
		cont++;
	} else cont = 1;
	if((is_drawable || actualFrame > 1)){
		updateTexture(); canyonPosition(posX, posY, frame);
	}
}

Sprite Canyon::getSprite(){
    return sprite;
}