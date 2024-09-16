#ifndef COMMON_POINTER_H
#define COMMON_POINTER_H
#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>

using namespace sf;

class Pointer {
	Texture texture;
	Sprite sprite;
	int frame;
	std::map <int, Vector2f> frames;
	bool is_enemy;
	int team;
		
	void fillFrames();

	void updateTexture();

	public:
	Pointer(RenderWindow &window, int team);

	void unit_move_mode();

	void normal_mode();

	void update(Vector2i &posicion, int posX, int posY, RenderWindow &window, std::map <int, Unit*> &units);

    void render(RenderWindow &window);
};
#endif
