#include <vector>
#include <iostream>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <SFML/Audio.hpp>
#include <time.h>
#include "common_assault.h"


using namespace sf;


Assault::Assault(std::map <int, Vector2f> &frames): frames(frames){
	image.loadFromFile("resources/Shoot.png");
	image.createMaskFromColor(sf::Color::White);
	Color gray = image.getPixel(25,5);
	image.createMaskFromColor(gray);
	texture.loadFromImage(image);
	sprite.setTexture(texture);
	sprite.setScale(Vector2f(0.2,0.2));
	cont = 1;
	buffer.loadFromFile("resources/sounds/attacks/manyshoots.wav");
	attackSound.setBuffer(buffer);
	attackSound.setVolume(1);
	actualFrame = 1;
}

void Assault::canyonPosition(float posX, float posY, int frame){
	switch(frame){
		case 5:
			sprite.setPosition(posX + 5, posY - 5);
			break;
		case 13:
			sprite.setPosition(posX + 5, posY + 5);
			break;
		case 9:
			sprite.setPosition(posX + 5, posY - 5);
			break;
		case 29:
			sprite.setPosition(posX - 5, posY - 5);
			break;
		case 21:
			sprite.setPosition(posX - 5, posY + 5);
			break;
		case 25:
			sprite.setPosition(posX - 5, posY - 5);
			break;
		case 17:
			sprite.setPosition(posX, posY + 5);
			break;
		case 1:
			sprite.setPosition(posX, posY - 5);
			break;	
	}
}


void Assault::updateTexture(){
	Vector2f &posicionFrameCanion = frames[actualFrame];
	sprite.setTextureRect(IntRect(posicionFrameCanion.x, posicionFrameCanion.y,125,125));
	actualFrame++;
	if(actualFrame == 26) actualFrame = 1;
}

void Assault::animate(float posX, float posY, bool is_attacking, int frame){
	bool is_drawable = false;
	if(is_attacking){
		if(cont % 30 == 0){
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
	} else {
		attackSound.stop();
	}
}


Sprite Assault::getSprite(){
    return sprite;
}