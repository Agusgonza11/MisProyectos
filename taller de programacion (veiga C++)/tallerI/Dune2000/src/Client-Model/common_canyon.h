#ifndef COMMON_CANYON_H
#define COMMON_CANYON_H
#include <vector>
#include <string>
#include <tuple>
#include <map>
#include <SFML/Graphics.hpp>
#include <time.h>
#include <SFML/Audio.hpp>


using namespace sf;


class Canyon {
	std::map <int, Vector2f> &frames;
    Sprite sprite;
	Texture texture;
	Image image;
	SoundBuffer buffer;
	Sound attackSound;
	int cont;
	int actualFrame;

	void canyonPosition(float posX, float posY, int frame);

	void updateTexture();

    public:

    Canyon(std::map <int, Vector2f> &frames);

	void animate(float posX, float posY, bool is_attacking, int frame);

    Sprite getSprite();

};
#endif