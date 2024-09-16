#ifndef COMMON_GAME_SCREEN_H
#define COMMON_GAME_SCREEN_H
#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "common_protocol.h"
//#include "common_socket.h"
#include "common_model.h"
#include "common_camera.h"
#include "common_pointer.h"
#include "common_music_controller.h"



class GameScreen {
	int posX;//Posiciones de la camara respecto al mapa
	int posY;
	MusicController musics;
	
	void check_events(Pointer &pointer, Event &event, Model &model, Protocol &protocol, int posX, int posY);
	
	void draw_elements(RenderWindow &window, Model &model, Camera &camera, int sizeX, int sizeY);

	void draw_units(RenderWindow &window, Model &model, Camera &camera, int sizeX, int sizeY);

	void draw_builds(RenderWindow &window, Model &model, Camera &camera, int sizeX, int sizeY);
	
	void draw_grounds(RenderWindow &window, Model &model, Camera &camera, int sizeX, int sizeY);

	void draw_explosions(RenderWindow &window, Model &model, Camera &camera, int sizeX, int sizeY);

	public:
	GameScreen();
	
	void show(Model &model, Protocol &protocol);

};
#endif
