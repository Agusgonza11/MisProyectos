#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "common_unit.h"
#include "common_ground.h"
#include "common_model.h"

Model::Model(std::vector<Unit*> &units, Ground &grounds): 
		units(units), grounds(grounds), one_unit_can_moves(false) {}
		
		
void Model::update_status(std::vector<Unit*> &units){
	for(int i = 0; i < units.size() ; i++){
		std::tuple<float> destiny = (units[i])->get_position();
		(*units[i])->setMove(std::get<0>(destiny), std::get<1>(destiny));
	}
}

/*
bool Model::have_unit_different_cords(Unit &unit){
	bool is_in = false;
	for(int i = 0; i < this->units.size() ; i++){
		if((this->units[i])->get_id_unit) == unit.get_id_unit()){
			std::tuple<float> origins = (this->units[i])->get_position();
			std::tuple<float> goes = unit.get_position();
			if(std::get<0>(origins) == std::get<0>(goes) && 
			std::get<1>(origins) == std::get<1>(goes)) is_in = true;
		}
	}
	return is_in;
}
*/

int Model::get_y_size(){
	return grounds.get_ground_y_size();
}

int Model::get_x_size(){
	return grounds.get_ground_x_size();
}

Unit Model::get_unit(float cordX, float cordY){
	Unit unit;
	for(int i = 0; i < this->units.size() ; i++){
		if((this->units[i])->is_there(cordX, cordY) unit = (*this->units[i]);	
	}
	return unit;
}


Unit Model::get_unit_can_moves(){
	Unit unit;
	for(int i = 0; i < this->units.size() ; i++){
		if((this->units[i])->can_moves()) unit = this->units[i];
	}
	return unit;	
}


bool Model::a_unit_can_moves(){
	return this->one_unit_can_moves;
}


void Model::unit_enable_move(int unit_id){
	for(int i = 0; i < this->units.size() ; i++){
		this->units[i].no_enable_move();
		if((this->units[i])->get_id_unit() == unit_id){
			(this->units[i])->enable_move();
			this->one_unit_can_moves = true;
		}
	}	
}


bool Model::is_unit_there(float cordX, float cordY){
	bool is_here = false;
	for(int i = 0; i < this->units.size() ; i++){
		Unit *ptr = this->units[i];
		if(ptr->is_there(cordX, cordY)) is_here = true;
	}	
	return is_here;
}



int Model::get_units_size(){
	return this->units.size();
}


Ground &Model::get_grounds(){
	return this->grounds;
}

	
std::vector<Units*> &Model::get_units(){
	return this->units;
}

void Model::deleteUnits(){
	for(int i = 0; i < this->units.size() ; i++){
		delete(*this->units[i]);
	}		
}


Model::~Model(){
	this->units.deleteUnits();
	~this->grounds;	
}



