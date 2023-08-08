#ifndef COMMON_UNIT_H
#define COMMON_UNIT_H
#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>

using namespace sf;

class Unit: public Drawable{
	Sprite sprite;
	Texture texture;
	bool can_move;
	float posX;
	float posY;
	float destX;
	float destY;
	float velocity;
	int largeBitsX;
	int largeBitsY;
	int id;
	std::map <int, Vector2f> frames;
	int actualFrame;
	
	public:
	virtual move();
	
	Unit unit();
	
	Unit unit(int cordX, int cordY, int id);
	
	void draw(RenderTarget &target, RenderStates states) const;
	
	bool is_there(float cord_x, float cord_y);
	
	void move();
	
	std::tuple<int> get_bits();

	bool is_there(float cord_x, float cord_y);
	
	void enable_move();
	
	void no_enable_move();
	
	bool can_moves();
	
	std::tuple<int> get_bits();
	
	void setLastMove(float x, float y);
	
	bool is_in_destiny();
	
	Unit& operator=(const Unit&& other);
};
#endif
