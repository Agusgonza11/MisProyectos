#ifndef COMMON_EXPLOSION_H
#define COMMON_EXPLOSION_H
#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>
#include <SFML/Audio.hpp>

using namespace sf;


class Explosion: public Drawable{
	Sprite sprite;
	Texture texture;
	Image image;
	SoundBuffer buffer;
	Sound sound;
	int frame;
	int lastFrame;
	int cont;
	bool is_finish;
	float x;
	float y;
	
    public:

	void draw(RenderTarget &target, RenderStates states) const;
	
	Explosion(float x, float y);

	bool finish();

	void animateExplosion();
	
	void updateTexture();
	
	std::tuple<int, int, int, int> get_bits();

};
#endif