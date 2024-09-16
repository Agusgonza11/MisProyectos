#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <SFML/Audio.hpp>
#include <time.h>
#include "common_unit.h"
#include "common_tank.h"
#include "common_canyon.h"
#include <iostream>

#define ALIAD 0
#define ENEMY -1
#define HARKONNEN 1
#define ATREIDES 2
#define ORDOS 3 

using namespace sf;

void TankClient::selectTexture(int side, int type){
	switch(type){
		case HARKONNEN:
			if(side == ALIAD) texture.loadFromFile("resources/units/harkonnenTank.png");
   			if(side == ENEMY){
				image.loadFromFile("resources/units/harkonnenTankenemy.png");
				image.createMaskFromColor(Color::White);
				texture.loadFromImage(image);
			}
			break;
		case ATREIDES:
			if(side == ALIAD) texture.loadFromFile("resources/units/atreidesTank.png");
			if(side == ENEMY){
				image.loadFromFile("resources/units/atreidesTankenemy.png");
				image.createMaskFromColor(Color::White);
				texture.loadFromImage(image);
			}
			break;
		case ORDOS:
			if(side == ALIAD) texture.loadFromFile("resources/units/ordosTank.png");
   			if(side == ENEMY){
				image.loadFromFile("resources/units/ordosTankenemy.png");
				image.createMaskFromColor(Color::White);
				texture.loadFromImage(image);
			}
			break;
	}
}



TankClient::TankClient(int side, int type, std::map <int, Vector2f> &frames, std::map <int, Vector2f> &canionFrames, int cordX, int cordY, int id, int team, int hp, std::map <int, Vector2f> &framesDamage): 
		Unit(cordX, cordY, id, team, hp, framesDamage), weapon(canionFrames), frames(frames) {
	selectTexture(side, type);
	sprite.setTexture(texture);
    sprite.setTextureRect(IntRect(5,2,30,25));
	sprite.setPosition(cordX, cordY);
    this->velocity = 0.8;	
	this->largeBitsX = 35;
	this->largeBitsY = 35;
	this->actualFrame = 17;
	this->actualFrameCanion = 49;
	canion.setTexture(texture);
	canion.setTextureRect(IntRect(8,109,10,18));
	canion.setPosition(cordX + 5, cordY + 1);
	buffer.loadFromFile("resources/sounds/moves/tankMove.wav");
	moveSound.setBuffer(buffer);
	moveSound.setVolume(5);
}

void TankClient::draw(RenderTarget &target, RenderStates states) const {
	if(hp < max_hp){
		target.draw(lifeMax, states);
		target.draw(lifeRest, states);
	}
	if(can_move) target.draw(selector);
	target.draw(sprite, states);
	target.draw(canion, states);
}

void TankClient::modifyMovePosition(bool moveRight, bool moveLeft, bool moveUp, bool moveDown){
	int frameDestiny = Unit::calculeFramePosition(moveRight, moveLeft, moveUp, moveDown);
	if(actualFrame > frameDestiny) actualFrame--;
	if(actualFrame < frameDestiny) actualFrame++;
	Vector2f &posicionFrame = frames[actualFrame];	
	sprite.setTextureRect(IntRect(posicionFrame.x, posicionFrame.y,30,25));
	actualFrameCanion = actualFrame + 32;
	Vector2f &posicionFrameCanion = frames[actualFrameCanion];
	canion.setTextureRect(IntRect(posicionFrameCanion.x, posicionFrameCanion.y,20,20));	
	canion.setPosition(posX + 5, posY + 1);
}


bool TankClient::updateCanion(){
	int frameDestiny = actualFrameCanion;
	bool is_attacking = false;
	bool moveRight = false; bool moveLeft = false; 
	bool moveUp = false; bool moveDown = false;
	if(attackX > posX && attackX - 15 > posX) moveRight = true;
	if(attackX < posX && attackX + 15 < posX) moveLeft = true;
	if(attackY > posY && attackY - 15 > posY) moveDown = true;
	if(attackY < posY && attackY + 15 < posY) moveUp = true;
	if(moveRight){
		if(moveUp) frameDestiny = 36;
		if(moveDown) frameDestiny = 46;
		else if(!moveUp && !moveDown) frameDestiny = 41;	
	}
	if(moveLeft){
		if(moveUp) frameDestiny = 61;
		if(moveDown) frameDestiny = 53;
		else if(!moveUp && !moveDown) frameDestiny = 57;		
	}
	if(!moveRight && !moveLeft && !moveUp && moveDown) frameDestiny = 49;
	if(!moveRight && !moveLeft && moveUp && !moveDown) frameDestiny = 33;

	if(actualFrameCanion > frameDestiny) actualFrameCanion--;
	if(actualFrameCanion < frameDestiny) actualFrameCanion++;
	if(actualFrameCanion == frameDestiny){
		weapon.animate(posX, posY, attacking, actualFrameCanion); is_attacking = true;
	}

	Vector2f &posicionFrameCanion = frames[actualFrameCanion];
	canion.setTextureRect(IntRect(posicionFrameCanion.x, posicionFrameCanion.y,20,20));
	return is_attacking;
}

Sprite TankClient::get_weapon(){
	return weapon.getSprite();
}

void TankClient::reproduceMove(){
	moveSound.play();
}


bool TankClient::animate_attack(){
	bool is_attacking = updateCanion();
	canion.setPosition(posX + 5,posY + 1);
	return is_attacking;
}

TankClient::~TankClient(){}
