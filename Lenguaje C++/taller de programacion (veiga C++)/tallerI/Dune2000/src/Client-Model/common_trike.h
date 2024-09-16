#ifndef COMMON_TRIKE_H
#define COMMON_TRIKE_H
#include <vector>
#include <string>
#include <tuple>
#include <SFML/Audio.hpp>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "common_unit.h"
#include "common_assault.h"


using namespace sf;

class TrikeClient: public Unit {
	Assault weapon;
	std::map <int, Vector2f> &frames;
	SoundBuffer buffer;
	Sound moveSound;
	Image image;

	
	bool pointTo();

	void selectTexture(int side);

	public:
	
	TrikeClient(int side, std::map <int, Vector2f> &frames, std::map <int, Vector2f> &framesAssault, int cordX, int cordY, 
							int id, int team, int hp, std::map <int, Vector2f> &framesDamage);

	virtual void modifyMovePosition(bool moveRight, bool moveLeft, 
								bool moveUp, bool moveDown) override;

	virtual bool animate_attack() override;

	virtual Sprite get_weapon() override;

	virtual void reproduceMove() override;

	virtual ~TrikeClient();

	
};
#endif
