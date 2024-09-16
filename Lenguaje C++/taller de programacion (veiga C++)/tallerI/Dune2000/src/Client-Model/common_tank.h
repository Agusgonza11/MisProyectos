#ifndef COMMON_TANK_H
#define COMMON_TANK_H
#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "common_unit.h"
#include "common_canyon.h"
#include <SFML/Audio.hpp>


using namespace sf;

class TankClient: public Unit {
	Canyon weapon;
	int actualFrameCanion;
	Sprite canion;
	std::map <int, Vector2f> &frames;
	SoundBuffer buffer;
	Sound moveSound;
	Image image;


    bool updateCanion();

	void selectTexture(int side, int type);

	public:
	TankClient(int side, int type, std::map <int, Vector2f> &frames, std::map <int, Vector2f> &canionFrames, 
									int cordX, int cordY, int id, int team, int hp, std::map <int, Vector2f> &framesDamage);
	
	void draw(RenderTarget &target, RenderStates states) const;

    virtual void modifyMovePosition(bool moveRight, bool moveLeft, 
							bool moveUp, bool moveDown) override;

    virtual bool animate_attack() override;

	virtual Sprite get_weapon() override;

	virtual void reproduceMove() override;
	
    virtual ~TankClient();

};
#endif