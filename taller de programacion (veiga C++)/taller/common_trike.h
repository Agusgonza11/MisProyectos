#ifndef COMMON_INFANTERY_H
#define COMMON_INFANTERY_H
#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "common_unit.h"

using namespace sf;

class Trike: public Unit{
	
	virtual void modifyMovePosition(bool moveRight, bool moveLeft, 
								bool moveUp, bool moveDown) override;
	
	void fillFrames();	

	public:
	
	Trike(int cordX, int cordY);

	
}
#endif
