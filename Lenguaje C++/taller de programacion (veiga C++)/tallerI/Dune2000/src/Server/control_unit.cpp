//
// Created by ignat on 30/05/22.
//

#include "control_unit.h"
#include "../Model/Entities/unit.h"

ControlUnit::ControlUnit(unsigned int rows, unsigned int cols) :
map(rows, cols),
entities(),
factory(this->map, this->entities){}

void ControlUnit::set_terrains(const Terrains &terrains)
{
	for (auto const &it : terrains) {
		if (not this->map.invalid_position(it.first))
			this->map.change_terrain(it.first, it.second);
	}
}

unsigned int ControlUnit::units_count() const
{
	return this->entities.size();
}

void ControlUnit::cmd_create(unsigned int player_id, unsigned int type_id, BlockPosition position)
{
	this->factory.create(player_id, type_id, position);
}

void ControlUnit::cmd_move(int id, BlockPosition destination)
{
	if (this->entities.count(id) == 0
	or this->map.invalid_position(destination))
		return;

	shared_ptr<Teamable> unit = this->entities.at(id);
	if (unit->is_movable())
		dynamic_pointer_cast<Unit>(unit)->move_to(destination);
	// hay que hacer el casteo a algo que entienda el comando mover
}

void ControlUnit::cmd_attack(unsigned int id, unsigned int target_id)
{
	if (this->entities.count(id) == 0
	or this->entities.count(target_id) == 0)
		return;

	shared_ptr<Teamable> unit = this->entities.at(id);
	if (unit->can_attack())
		dynamic_pointer_cast<Unit>(unit)->attack(target_id);
	// idem que para mover
}

void ControlUnit::update(unsigned int time_delta)
{
	for (auto &it : this->entities)
		dynamic_pointer_cast<Unit>(it.second)->update(time_delta);

	for (auto it = this->entities.begin(); it != this->entities.end(); it++) {
		if (it->second->is_dead())
			it = this->entities.erase(it);
	}
}

std::vector <shared_ptr<Teamable>> ControlUnit::get_state() const
{
	vector<shared_ptr<Teamable>> tmp_entities;
	for (auto const &it : this->entities)
		tmp_entities.push_back(it.second);

	return tmp_entities;
}

ControlUnit::~ControlUnit() = default;