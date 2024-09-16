#include <iostream>
#include <string>
#include <fstream>
#include <arpa/inet.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <cstring>
#include <typeinfo>
#include <tuple>
#include <map>
#include "client_class.h"
#include <vector>
#include <sstream>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "common_protocol.h"
//#include "common_socket.h"
#include "common_model.h"
#include "common_game_screen.h"
#include "common_unit.h"
#include "common_camera.h"
#include "common_ground.h"
#include "common_pointer.h"
#include "ConstructionMenu.h"


using namespace sf;


GameScreen::GameScreen(): posX(0), posY(0), musics{} {}


void GameScreen::draw_grounds(RenderWindow &window, Model &model, Camera &camera, int sizeX, int sizeY){
	int posX = camera.get_posX();
	int posY = camera.get_posY();
	int limitX = posX +  sizeX;
	int limitY = posY + sizeY;
	Ground &ground = model.get_grounds();
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
}

void GameScreen::draw_units(RenderWindow &window, Model &model, Camera &camera, int sizeX, int sizeY){
	for(size_t i = 0; i < model.get_units_to_eliminate().size(); i++){
		bool is_finish = model.get_units_to_eliminate()[i]->animate_destruction();
		if(!is_finish) window.draw(*model.get_units_to_eliminate()[i]);
		else {
			model.eliminate_unit(i);
		}
	}
	size_t count = 0;
	for(auto iter = model.get_units().begin(); iter != model.get_units().end(); ++iter){
		model.move_by_position(iter->first);
		std::tuple<int, int, int, int> uBits = iter->second->get_bits();
		if(camera.appears_in_view(std::get<0>(uBits), std::get<1>(uBits), 
								std::get<2>(uBits), std::get<3>(uBits))){
			if(iter->second->was_damaged()) iter->second->animate_damage();
			window.draw(*iter->second);
			if(iter->second->is_attacking()){
				count++;
				musics.reproduceAttacking();
				if(iter->second->animate_attack()) window.draw(iter->second->get_weapon());
			}
		}
	}
	if(count == 0) musics.reproducePredifine();
}


void GameScreen::draw_explosions(RenderWindow &window, Model &model, Camera &camera, int sizeX, int sizeY){
	for(size_t i = 0; i < model.get_explosions().size(); i++){
		if(!model.get_explosions()[i]->finish()){
			model.get_explosions()[i]->animateExplosion();
			std::tuple<int, int, int, int> eBits = model.get_explosions()[i]->get_bits();
			if(camera.appears_in_view(std::get<0>(eBits), std::get<1>(eBits), 
									std::get<2>(eBits), std::get<3>(eBits))){
				window.draw(*model.get_explosions()[i]);
			}
		} else model.delete_explosion(i);
	}
}


void GameScreen::draw_elements(RenderWindow &window, Model &model, Camera &camera, int sizeX, int sizeY){
	draw_grounds(window, model, camera, sizeX, sizeY);
	draw_units(window, model, camera, sizeX, sizeY);
	draw_explosions(window, model, camera, sizeX, sizeY);
}



void GameScreen::check_events(Pointer &pointer, Event &event, Model &model, 
			Protocol &protocol, int posX, int posY){
	if(event.mouseButton.button == Mouse::Left){
		if(model.is_unit_there(event.mouseButton.x + posX, event.mouseButton.y + posY)){
			int unit = model.get_unit(event.mouseButton.x + posX, event.mouseButton.y + posY);
			model.unit_enable_move(unit); 
			pointer.unit_move_mode();
		} else {
			model.no_enable_moves();
			pointer.normal_mode();
		} 
	}
	if(event.mouseButton.button == Mouse::Right){
		if(model.a_unit_can_moves()){
			std::vector<int> units_to_move = model.get_units_can_moves();
			for(size_t i = 0; i < units_to_move.size(); i++){
				if(model.is_enemy_there(event.mouseButton.x + posX, event.mouseButton.y + posY)){
					int enemy_unit = model.get_unit(event.mouseButton.x + posX, event.mouseButton.y + posY);
					protocol.send_unit_attack(units_to_move[i], enemy_unit);
				} else {
					protocol.send_unit_move(units_to_move[i], event.mouseButton.x + posX, 
											event.mouseButton.y + posY);
				}
				model.reproduceSoundMove(units_to_move[i]);
			}
		}
	}
}


void GameScreen::show(Model &model, Protocol &protocol){
    int sizeX = 1150;//Esto en un futuro es
    int sizeY = 700;//Algo que se pasa por parametro
    RenderWindow window(VideoMode(sizeX, sizeY), "DUNE");

    View menu_view;
    menu_view.setViewport(sf::FloatRect(0.81f, 0.f, 0.25f, 0.70f));
    ConstructionMenu menu(0,0,700,1000,"Atreides",protocol);

    View view;
    view.setViewport(sf::FloatRect(0.f, 0.f, 1.0f, 1.0f));
    Camera camera(view, this->posX, this->posY, sizeX, sizeY);

    Pointer pointer(window, model.get_team());

    while(window.isOpen()){
        Vector2i posicion = Mouse::getPosition(window);
        camera.update(posicion, model);
		model.update(protocol.receive_units(model.get_units(), model.get_team()));
		//
        Event event;
        while(window.pollEvent(event)){
            if(event.type == Event::Closed){
                window.close();
            }
            check_events(pointer, event, model, protocol, this->posX, this->posY);
            menu.update(event,window);
        }
        camera.render(window);
        window.clear();
        window.setView(view);
        draw_elements(window, model, camera, sizeX, sizeY);
        pointer.update(posicion, posX, posY, window, model.get_units());
        window.setView(menu_view);
        pointer.render(window);
        menu.render(window);
        pointer.render(window);
        window.display();
        protocol.update();
		musics.reproduce();
    }
}
