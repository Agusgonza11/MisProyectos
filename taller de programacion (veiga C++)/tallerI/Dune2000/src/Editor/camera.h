#ifndef COMMON_CAMERA_H
#define COMMON_CAMERA_H
#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "ground.h"

using namespace sf;

class Camera {
	public:
	View &view;
	int &posX;
	int &posY;
	int sizeX;
	int sizeY;
	
	Camera(View &view, int &posX, int &posY, int sizeX, int sizeY);
	
	void render(RenderWindow &window);
	
	void update(Vector2i &posicion, Ground &ground);
	
	bool appears_in_view(int objectX, int objectY, int largeX, int largeY);
	
	int get_posX();
	
	int get_posY();
};
#endif
