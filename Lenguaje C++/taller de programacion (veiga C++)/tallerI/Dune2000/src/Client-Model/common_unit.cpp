#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "common_unit.h"
#include "common_assault.h"

#include <iostream>



Unit::Unit(int cordX, int cordY, int id, int team, int hp, std::map <int, Vector2f> &frames): posX(cordX), posY(cordY), 
	can_move(false), destX(cordX), destY(cordY), id(id), selector{}, team(team),
	hp(hp), max_hp(hp), attacking(false), damaged(false), actualFrameDamage(1), damageFrames(frames) {
		lifeMax.setSize(Vector2f(30,3));
		lifeMax.setFillColor(sf::Color::Black);
		lifeMax.setPosition(cordX, cordY - 5);
		lifeRest.setPosition(cordX, cordX - 5);
		damageTexture.loadFromFile("resources/hit.png");
		damageSprite.setTexture(damageTexture);
		damageSprite.setScale(0.2,0.2);
	}


void Unit::draw(RenderTarget &target, RenderStates states) const {
	if(hp < max_hp){
		target.draw(lifeMax, states);
		target.draw(lifeRest, states);
	}
	if(can_move) target.draw(selector);
	target.draw(sprite, states);
	if(damaged) target.draw(damageSprite);
}


bool Unit::is_there(float cord_x, float cord_y){
	int is_in = 0;
	if(this->posX <= cord_x && cord_x <= this->posX + this->largeBitsX) is_in += 1;
	if(this->posY <= cord_y && cord_y<= this->posY + this->largeBitsY) is_in += 1;
	return is_in == 2;
}

void Unit::animate_damage(){
	Vector2f &posicionFrame = damageFrames[actualFrameDamage];
	damageSprite.setTextureRect(IntRect(posicionFrame.x, posicionFrame.y,170,225));
	damageSprite.setPosition(posX,posY);
	actualFrameDamage++;
	if(actualFrameDamage == 6){ actualFrameDamage = 1; damaged = false; }
}

Sprite Unit::get_weapon(){
	Sprite x;
	return x;
}

void Unit::setNeutral(){
	attacking = false;
}

void Unit::setMove(float x, float y){
	this->destX = x;
	this->destY = y;
}

void Unit::setAttack(std::tuple<float, float> position_target){
	this->attackX = std::get<0>(position_target);
	this->attackY = std::get<1>(position_target);
	this->attacking = true;
}

bool Unit::is_attacking(){
	return attacking;
}

void Unit::enable_move(){
	this->can_move = true;
	selector.enable_selection(posX, posY);
}

int Unit::get_id_unit(){
	return this->id;
}

int Unit::get_hp(){
	return hp;
}


void Unit::modifyHp(int new_hp){
	int life = hp * 30 / max_hp;
	lifeRest.setSize(Vector2f(life,3));
	int porcentual_life = hp * 100 / max_hp;
	if(porcentual_life < 30){
		lifeRest.setFillColor(sf::Color::Red);
	} else {
		lifeRest.setFillColor(sf::Color::Green);
	}
	if(this->hp > new_hp) damaged = true;
	this->hp = new_hp;
	lifeMax.setPosition(posX, posY - 5);
	lifeRest.setPosition(posX, posY - 5);
}

bool Unit::was_damaged(){
	return damaged;
}

void Unit::no_enable_move(){
	this->can_move = false;
}

bool Unit::can_moves(){
	return this->can_move;
}

std::tuple<int, int, int, int> Unit::get_bits(){
	return std::make_tuple(posX, posY, largeBitsX, largeBitsY);
}

bool Unit::is_in_destiny(){
	return destX == posX && destY == posY;
}

int Unit::get_team(){
	return team;
}

bool Unit::animate_destruction(){
	can_move = false;
	max_hp = hp;
	Color color = sprite.getColor();
	uint8_t transparency = color.a;
	if(transparency > 10){
		transparency -= 30;
		sprite.setColor(sf::Color(255,255,255,transparency));
		return false; 
	} else {

		return true;
	}
}

int Unit::calculeFramePosition(bool moveRight, bool moveLeft, bool moveUp, bool moveDown){
	int frameDestiny = 0;
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
	return frameDestiny;
}

void Unit::move(){
	float moveX = posX;
	float moveY = posY;
	bool moveRight = false; bool moveLeft = false; 
	bool moveUp = false; bool moveDown = false;
	if( (int) destX > (int) posX){
		moveX +=  velocity;
		moveRight = true;
		attacking = false;
	} else if((int) destX < (int) posX){
		moveX -=  velocity;
		moveLeft = true;
		attacking = false;
	}
	if( (int) destY > (int) posY){
		moveY +=  velocity;
		moveDown = true;
		attacking = false;
	} else if((int) destY < (int) posY){
		moveY -=  velocity;
		moveUp = true;
		attacking = false;
	}
	modifyMovePosition(moveRight, moveLeft, moveUp, moveDown);
	sprite.setPosition(moveX, moveY);
	selector.enable_selection(moveX, moveY);
	lifeMax.setPosition(moveX, moveY - 5);
	lifeRest.setPosition(moveX, moveY - 5);
	this->posX = moveX;
	this->posY = moveY;
	if((int) moveX == (int) destX) this->destX = moveX;
	if((int) moveY == (int) destY) this->destY = moveY;	
}

std::tuple<float, float> Unit::get_position(){
	return std::make_tuple(this->posX, this->posY);
}

