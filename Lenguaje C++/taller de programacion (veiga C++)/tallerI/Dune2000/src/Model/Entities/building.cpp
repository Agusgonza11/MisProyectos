//
// Created by ignat on 18/06/22.
//

#include "building.h"
#include "../configurations.h"

Building::Building(unsigned int id, unsigned int player_id, unsigned int hp,
		   BlockPosition pos_, unsigned int width_, unsigned int length_,
		   unsigned int energy_consumption) :
	Teamable(id, player_id, hp),
	pos(pos_),
	width(width_),
	length(length_),
	energy(energy_consumption){}

bool Building::is_movable() const
{
	return false;
}

bool Building::can_attack() const
{
	return false;
}

bool Building::is_damageable() const
{
	return true;
}

bool Building::changed_position() const
{
	return false;
}

double Building::distance_to(BlockPosition position) const
{
	double distance = this->pos.distance_to(position);
	unsigned int row = this->pos.row();
	unsigned int col = this->pos.col();
	for (unsigned int i = 0; i < this->length; i++) {
		for (unsigned int j = 0; j < this->width; j++) {
			double tmp = position.distance_to(BlockPosition(row + i, col + j));
			distance = distance <= tmp ? distance : tmp;
		}
	}
	return distance;
}

std::vector<BlockPosition> Building::positions_at_range(unsigned short range) const
{
	std::vector<BlockPosition> positions;
	unsigned int row = this->pos.row();
	unsigned int col = this->pos.col();
	int i, j;

	for (i = -range; i < (int) this->length + range; i++) {
		for (j = -range; j < (int) this->width + range; j++) {
			BlockPosition position(row + i, col + j);
			if (this->distance_to(position) <= range)
				positions.push_back(position);
		}
	}
	return positions;
}

std::vector <BlockPosition> Building::occupied_space() const
{
	std::vector<BlockPosition> positions;
	unsigned int row = this->pos.row();
	unsigned int col = this->pos.col();
	for (unsigned int i = 0; i < this->length; i++) {
		for (unsigned int j = 0; j < this->width; j++)
			positions.push_back(BlockPosition(row + i, col + j));
	}
	return positions;
}

unsigned int Building::energy_consumed() const
{
	return this->energy;
}

unsigned int Building::get_class_id() const
{
	return CONFIGS.BUILDING_CLASS_ID;
}

Building::~Building() = default;

