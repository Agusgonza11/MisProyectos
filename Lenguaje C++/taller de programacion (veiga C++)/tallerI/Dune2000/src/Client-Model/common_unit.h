#ifndef COMMON_UNIT_H
#define COMMON_UNIT_H
#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "common_selector.h"

using namespace sf;

class Unit: public Drawable{
	public: 
	float posX;
	float posY;
	bool can_move;
	float destX;
	float destY;
	int id;
	float velocity;
	int largeBitsX;
	int largeBitsY;
	int actualFrame;
	Sprite sprite;
	Texture texture;
	Selector selector;
	RectangleShape lifeMax;
	RectangleShape lifeRest;
	int team;
	int hp;
	int max_hp;
	bool attacking;
	int attackX;
	int attackY;
	bool damaged;
	Texture damageTexture;
	Sprite damageSprite;
	int actualFrameDamage;
	std::map <int, Vector2f> &damageFrames;


	virtual void modifyMovePosition(bool moveRight, bool moveLeft, 
								bool moveUp, bool moveDown);
	
	Unit(int cordX, int cordY, int id, int team, int hp, std::map <int, Vector2f> &frames);
	
	void draw(RenderTarget &target, RenderStates states) const;
	
	void move();
	
	std::tuple<int, int, int, int> get_bits();

	bool is_there(float cord_x, float cord_y);
	
	void enable_move();

	virtual Sprite get_weapon();
	
	void no_enable_move();

	bool was_damaged();

	virtual bool animate_attack();

	void animate_damage();
	
	bool can_moves();
	
	void setMove(float x, float y);

	void setAttack(std::tuple<float, float> position_target);

	virtual void reproduceMove();
	
	bool is_in_destiny();

	bool is_attacking();
	
	int get_id_unit();

	int get_team();

	int get_hp();

	void setNeutral();

	void modifyHp(int new_hp);

	int calculeFramePosition(bool moveRight, bool moveLeft, bool moveUp, bool moveDown);

	bool animate_destruction();
	
	std::tuple<float, float> get_position();
	
};
#endif
