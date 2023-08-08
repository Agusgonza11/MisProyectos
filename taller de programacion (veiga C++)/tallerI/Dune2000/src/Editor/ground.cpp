#include <vector>
#include <SFML/Graphics.hpp>
#include <iostream>
#include "ground.h"

#include "ConstantGetter.h"

using namespace sf;

void Ground::draw(RenderTarget &target, RenderStates states) const {
	target.draw(sprite, states);
}

Ground::Ground(std::vector<std::vector<int> >& level, int lenght, int width): map(level),
					lengthMap(lenght), widthMap(width) {
    int TSIZE = ConstantGetter::getTsize();
    texture.loadFromFile(ConstantGetter::getResourcePath() + "terrain.bmp");
	sprite.setTexture(texture);
    sprite.setScale(Vector2f(TSIZE/16,TSIZE/16));
    //sprite.setSize(Vector2f(TSIZE,TSIZE));
}

void Ground::is_sand(){
	sprite.setTextureRect(IntRect(0,8,16,16));
}
	
void Ground::is_rock(){
	sprite.setTextureRect(IntRect(112,240,16,16));
}
	
void Ground::is_spice(){
	sprite.setTextureRect(IntRect(0,305,16,16));
}

void Ground::is_cliff() {
    sprite.setTextureRect(IntRect(90,40,16,16));
}

void Ground::is_top() {
    sprite.setTextureRect(IntRect(144,100,16,16));
}

void Ground::is_dune() {
    sprite.setTextureRect(IntRect(16,280,16,16));
}

void Ground::set(int x, int y){
	sprite.setPosition((float) x,(float)y);
}

bool Ground::identify_texture(int col, int row){
	bool identify = false;
	if(col >= lengthMap || row >= widthMap) return false;
	switch(map[row][col]){
		case 0:
			is_sand(); identify = true;
			break;
		case 1:
			is_rock(); identify = true;
			break;
		case 2:
			is_spice(); identify = true;
			break;
        case 3:
            is_cliff(); identify = true;
            break;
        case 4:
            is_top(); identify = true;
            break;
        case 5:
            is_dune(); identify = true;
            break;
	}
	return identify;
}


//
int Ground::get_ground_y_size() const{
    int TSIZE = ConstantGetter::getTsize();
    return lengthMap * TSIZE;
}
	
int Ground::get_ground_x_size() const{
    int TSIZE = ConstantGetter::getTsize();
    return widthMap * TSIZE;
}

void Ground::setsSprite(int x, int y, int code) {
    map[x][y] = code;

}

int Ground::getTexture(int x , int y){
    return map[y][x];
}


