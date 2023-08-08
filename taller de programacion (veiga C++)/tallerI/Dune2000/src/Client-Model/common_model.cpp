#include <vector>
#include <string>
#include <tuple>
#include <map>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "common_unit.h"
#include "common_ground.h"
#include "common_model.h"
#include "common_explosion.h"
#include "../Server/mock_server.h"
#include <iostream>


Model::Model(std::map <int, Unit*> &units, Ground &grounds, int team): 
		units(units), ground(grounds), one_unit_can_moves(false), team(team) {}
		
	
void Model::foundEliminate(std::vector<struct RawUnit> &received_units){
	bool is = false;
	for(auto iter = units.begin(); iter != units.end(); ++iter){
		if(units.size() == 1) break;
		for(size_t i = 0; i < received_units.size(); i++){
			if((unsigned int) iter->first == received_units[i].id){
				is = true;
			}
		}
		if(!is){
			units_to_eliminate.push_back(iter->second);
			std::tuple<float, float> position = iter->second->get_position();
			explosions.push_back(new Explosion(std::get<0>(position) - 10, std::get<1>(position) - 10));
			//delete iter->second;
			units.erase(iter);
		} 
		is = false;
	}	
}


void Model::update(std::vector<struct RawUnit> received_units){
	if(received_units.size() < units.size()) foundEliminate(received_units);
}


int Model::get_team(){
	return team;
}

int Model::get_y_size(){
	return ground.get_ground_y_size();
}

int Model::get_x_size(){
	return ground.get_ground_x_size();
}

int Model::get_unit(float cordX, float cordY){
	int id = 0;
	for(auto iter = units.begin(); iter != units.end(); ++iter){
		if(iter->second->is_there(cordX, cordY)) id = iter->second->get_id_unit();
	}	
	return id;
}


std::vector<int> Model::get_units_can_moves(){
	std::vector<int> ids;
	for(auto iter = units.begin(); iter != units.end(); ++iter){
		if(iter->second->can_moves()) ids.push_back(iter->first);
	}	
	return ids;	
}

void Model::no_enable_moves(){
	if(a_unit_can_moves()){
		for(auto iter = units.begin(); iter != units.end(); ++iter){
			iter->second->no_enable_move();
		}	

	}
	this->one_unit_can_moves = false;
}


bool Model::a_unit_can_moves(){
	return this->one_unit_can_moves;
}

std::vector<Explosion*> Model::get_explosions(){
	return explosions;
}

void Model::unit_enable_move(int unit_id){
	units[unit_id]->enable_move();
	this->one_unit_can_moves = true;
}


bool Model::is_unit_there(float cordX, float cordY){
	bool is_here = false;
	for(auto iter = units.begin(); iter != units.end(); ++iter){
		if(iter->second->is_there(cordX, cordY) && iter->second->get_team() == team) is_here = true;
	}	
	return is_here;
}

bool Model::is_enemy_there(float cordX, float cordY){
	bool is_here = false;
	for(auto iter = units.begin(); iter != units.end(); ++iter){
		if(iter->second->is_there(cordX, cordY) && iter->second->get_team() != team) is_here = true;
	}	
	return is_here;
}

void Model::move_by_position(int id){
	if(!units[id]->is_in_destiny()) units[id]->move();
}

std::vector<Unit*> Model::get_units_to_eliminate(){
	return units_to_eliminate;
}

int Model::get_units_size(){
	return this->units.size();
}


Ground &Model::get_grounds(){
	return this->ground;
}

void Model::reproduceSoundMove(int id){
	units[id]->reproduceMove();
}


void Model::eliminate_unit(size_t position){
	auto elem_to_remove = units_to_eliminate.begin() + position;
	units_to_eliminate.erase(elem_to_remove);
}
	
std::map <int, Unit*> &Model::get_units(){
	return this->units;
}

void Model::delete_explosion(int i){
	delete explosions[i];
	explosions.erase(explosions.begin() + i);
}

void Model::deleteUnits(){
    units.clear();
}


Model::~Model(){
	deleteUnits();
	//~this->ground;	
}



