//
// Created by ignat on 18/06/22.
//

#include "trike.h"
#include "../configurations.h"

Trike::Trike(unsigned int id, unsigned int player_id, BlockPosition position,
	     const TerrainMap &map_, std::map<unsigned int, TeamablePtr> &game_objects,
	     float creation_mod) :
	Unit(id, player_id, CONFIGS.TRIKE_HP, position, map_, game_objects,
	     CONFIGS.TRIKE_CREATION_TIME / creation_mod){}

unsigned int Trike::get_class_id() const
{
	return CONFIGS.VEHICLE_CLASS_ID;
}

unsigned int Trike::get_type_id() const
{
	return CONFIGS.TRIKE_ID;
}

unsigned int Trike::get_weapon_id() const
{
	return this->rifle.get_weapon_id();
}

unsigned int Trike::get_range() const
{
	return CONFIGS.TRIKE_RANGE;
}

Trike::~Trike() = default;

const UnitMobility &Trike::get_mobility() const
{
	return this->mob;
}

bool Trike::can_traverse(BlockTerrain terrain) const
{
	return this->mob.can_traverse(terrain);
}

unsigned int Trike::traverse_time(BlockTerrain terrain) const
{
	if (terrain == dunes)
		return 2 * CONFIGS.TRIKE_TRAVERSE_TIME;
	else
		return CONFIGS.TRIKE_TRAVERSE_TIME;
}

Weapon &Trike::get_weapon()
{
	return this->rifle;
}
