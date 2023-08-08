#include <iostream>
#include <string>
#include <fstream>
#include <stdlib.h>
#include <tuple>
#include <vector>
#include <sstream>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "common_ground.h"

using namespace sf;

void Ground::draw(RenderTarget &target, RenderStates states) const {
	target.draw(sprite, states);
}

Ground::Ground(std::vector<std::vector<int> > level, int lenght, int width): map(level), 
					lengthMap(lenght), widthMap(width) {
	texture.loadFromFile("resources/terrains/terrain.bmp");
	sprite.setTexture(texture);
}

void Ground::is_sand(){
	sprite.setTextureRect(IntRect(0,8,16,16));
}
	
void Ground::is_rock(){
	sprite.setTextureRect(IntRect(112,240,16,16));
}
	
void Ground::is_dune(){
	//Hay que arreglarlo
	sprite.setTextureRect(IntRect(112,240,16,16));
}

void Ground::is_spice(){
	sprite.setTextureRect(IntRect(0,305,16,16));
}

void Ground::is_cliff(){
	sprite.setTextureRect(IntRect(96,40,16,16)); 
}

void Ground::set(int x, int y){
	sprite.setPosition(x,y);
}

bool Ground::identify_texture(int col, int row){
	bool identify = false;
	if(col >= lengthMap || row >= widthMap) return false;
	switch(map[row][col]){
		case 0:
			is_sand(); identify = true;
			break;
		case 1:
			is_dune(); identify = true;
			break;
		case 2:
			is_rock(); identify = true;
			break;
		case 3:
			is_spice(); identify = true;
			break;
		case 4:
			is_cliff(); identify = true;
			break;
	}
	return identify;
}


//
int Ground::get_ground_y_size(){
	return lengthMap * 16;
}
	
int Ground::get_ground_x_size(){
	return widthMap * 16;
}

