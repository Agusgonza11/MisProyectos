#ifndef COMMON_MODEL_H
#define COMMON_MODEL_H
#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>

class Camera {
	public:
	int &posX;
	int &posY;
	int sizeX;
	int sizeY;
	View &view;
	
	Camera(View &view, int &posX, int &posY, int sizeX, int sizeY);
	
	void render(RenderWindow &window);
	
	void update(Vector2i &posicion, Model &model);
	
	bool appears_in_view(int objectX, int objectY, int largeX, int largeY);
	
	int get_posX();
	
	int get_posY();
}
#endif
