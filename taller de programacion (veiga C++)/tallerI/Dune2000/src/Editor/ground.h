#ifndef COMMON_GROUND_H
#define COMMON_GROUND_H
#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>

using namespace sf;

class Ground: public Drawable{
	Texture texture;

	std::vector<std::vector<int> >& map;
	int lengthMap; int widthMap;
	
	void is_sand();
	
	void is_rock();
	
	void is_spice();

    void is_cliff();

    void is_top();

    void is_dune();


	public:
    Sprite sprite;

	Ground(std::vector<std::vector<int> >& level, int lenght, int width);
	
	bool identify_texture(int col, int row);
	
	void set(int x, int y);
	
	void draw(RenderTarget &target, RenderStates states) const;
	
    void setsSprite(int x, int y, int code);

	int get_ground_y_size() const;
	
	int get_ground_x_size() const;


    int getTexture(int x, int y);
};
#endif
