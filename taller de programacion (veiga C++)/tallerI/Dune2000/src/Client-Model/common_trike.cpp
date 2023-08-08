#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <SFML/Audio.hpp>
#include <time.h>
#include "common_unit.h"
#include "common_trike.h"
#include "common_assault.h"
#include <iostream>

#define ALIAD 0
#define ENEMY -1

using namespace sf;

void TrikeClient::selectTexture(int side){
	if(side == ALIAD){
		texture.loadFromFile("resources/units/trike.png");
	}
	if(side == ENEMY){
		image.loadFromFile("resources/units/trikeenemy.png");
		image.createMaskFromColor(Color::White);
		texture.loadFromImage(image);
	}
}

TrikeClient::TrikeClient(int side, std::map <int, Vector2f> &frames, std::map <int, Vector2f> &framesAssault, int cordX, int cordY, int id, int team, int hp, std::map <int, Vector2f> &framesDamage): 
	Unit(cordX, cordY, id, team, hp, framesDamage), weapon(framesAssault), frames(frames) {
	selectTexture(side);
	sprite.setTexture(texture);
	sprite.setTextureRect(IntRect(5,60,30,30));
	sprite.setPosition(cordX, cordY);
	this->velocity = 0.35;
	this->largeBitsX = 35;
	this->largeBitsY = 35;
	this->actualFrame = 17;
	buffer.loadFromFile("resources/sounds/moves/trikeMove.wav");
	moveSound.setBuffer(buffer);
	moveSound.setVolume(5);
}


void TrikeClient::modifyMovePosition(bool moveRight, bool moveLeft, bool moveUp, bool moveDown){
	int frameDestiny = Unit::calculeFramePosition(moveRight, moveLeft, moveUp, moveDown);
	if(actualFrame > frameDestiny) actualFrame--;
	if(actualFrame < frameDestiny) actualFrame++;
	Vector2f &posicionFrame = frames[actualFrame];	
	sprite.setTextureRect(IntRect(posicionFrame.x, posicionFrame.y,30,25));
	}
	
bool TrikeClient::animate_attack(){
	bool is_attacking = pointTo();
	sprite.setPosition(posX,posY);
	return is_attacking;
}

void TrikeClient::reproduceMove(){
	moveSound.play();
}


bool TrikeClient::pointTo(){
	int frameDestiny = actualFrame;
	bool is_attacking = false;
	bool moveRight = false; bool moveLeft = false; 
	bool moveUp = false; bool moveDown = false;
	if(attackX > posX && attackX - 15 > posX) moveRight = true;
	if(attackX < posX && attackX + 15 < posX) moveLeft = true;
	if(attackY > posY && attackY - 15 > posY) moveDown = true;
	if(attackY < posY && attackY + 15 < posY) moveUp = true;
	frameDestiny = Unit::calculeFramePosition(moveRight, moveLeft, moveUp, moveDown);

	if(actualFrame > frameDestiny) actualFrame--;
	if(actualFrame < frameDestiny) actualFrame++;
	if(actualFrame == frameDestiny){ 
		weapon.animate(posX, posY, attacking, actualFrame); is_attacking = true;
	}

	Vector2f &posicionFrame = frames[actualFrame];
	sprite.setTextureRect(IntRect(posicionFrame.x, posicionFrame.y,30,25));
	return is_attacking;
}

Sprite TrikeClient::get_weapon(){
	return weapon.getSprite();
}

TrikeClient::~TrikeClient(){}

