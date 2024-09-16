#ifndef COMMON_SELECTOR_H
#define COMMON_SELECTOR_H
#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>

using namespace sf;

class Selector: public Drawable{
	Sprite sprite;
	Texture texture;

	public:
    
	void draw(RenderTarget &target, RenderStates states) const;
	
	Selector();
	
	void enable_selection(float x, float y);
};
#endif