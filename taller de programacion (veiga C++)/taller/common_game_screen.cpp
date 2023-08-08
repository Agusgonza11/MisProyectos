#include <iostream>
#include <string>
#include <fstream>
#include <arpa/inet.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <cstring>
#include <tuple>
#include "client.h"
#include <vector>
#include <sstream>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "common_protocol.h"
#include "common_socket.h"
#include "common_model.h"
#include "common_game_screen.h"
#include "common_unit.h"
#include "common_ground.h"

using namespace sf;


GameScreen::GameScreen(): posX(0), posY(0) {}


void GameScreen::draw_elements(RenderWindow &window, Model &model, 
		Camera &camera, int sizeX, int sizeY){
	int posX = camera.get_x();
	int posY = camera.get_y();
	int limitX = posX +  sizeX;
	int limitY = posY + sizeY;
	Ground &ground = model.get_ground();
	for(int i = posX; i < limitX; i+=16){
		for(int j = posY; j < limitY; j +=16){
			int col = i / 16;
			int row = j / 16;
			if(ground.identify_texture(col, row)){
				ground.set(i,j);
				window.draw(ground);
			}
		}
	}


	for(int i = 0; i < model.get_units_size() ; i++){
		if(!model.get_units()[i]->is_in_destiny()) (model.get_units()[i])->move();
		std::tuple<int, int, int, int> uBits = (model.get_units()[i])->get_bits();
		if(camera.appears_in_view(std::get<0>(uBits), std::get<1>(uBits), 
								std::get<2>(uBits), std::get<3>(uBits))){
			window.draw(*(model.get_units()[i]));
		}
	}
}



void GameScreen::check_events(Event &event, Model &model, 
			ProtocolGame &protocol, Socket &conexion, int posX, int posY){
	if(event.mouseButton.button == Mouse::Left){
		if(model.is_unit_there(event.mouseButton.x + posX, event.mouseButton.y + posY){
			Unit unit = model.get_unit(event.mouseButton.x + posX, event.mouseButton.y + posY);
			model.unit_enable_move(unit.get_id_unit();); 
			//todas las otras units quedan inhabilitadas para moverse
		} else if(model.a_unit_can_moves()){
			Unit unit = model.get_unit_can_moves();
			protocol.send_unit_move(conexion, unit, event.mouseButton.x + posX, 
													event.mouseButton.y + posY);
		} /*else if(model.is_unit_there(event.mouseButton.x + posX, 
					event.mouseButton.y + posY && model.a_unit_can_moves()){
			Unit unit = model.get_unit_can_moves();
			Unit enemy = model.get_unit(event.mouseButton.x + posX, event.mouseButton.y + posY);
			protocol.send_unit_atack(socket, unit, enemy);
		}*/
	}
}


void GameScreen::show(Model &model, ProtocolGame &protocol, Socket &conexion, bool was_closed){
	int sizeX = 500;//Esto en un futuro es 
	int sizeY = 500;//Algo que se pasa por parametro
	RenderWindow window(VideoMode(sizeX, sizeY), "DUNE");
	
	View view;
	Camera camera(view, this->posX, this->posY, sizeX, sizeY);
	
	while(window.isOpen()){
		this->protocol.update();
		Vector2i posicion = Mouse::getPosition(window);	
		camera.update(posicion, model);	
		model.update_status(protocol.receive_units(conexion, &was_closed));
		Event event;
		while(window.pollEvent(event)){
			if(event.type == Event::Closed){
				window.close();
			}
			check_events(event, model, protocol, this->posX, this->posY);
		}
		camera.render(window);
		window.clear();
		draw_elements(window, model, camera, sizeX, sizeY);
		window.display();
	}	
}
