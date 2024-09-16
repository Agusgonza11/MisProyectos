//
// Created by ignat on 13/06/22.
//

#include "tank.h"
#include "../configurations.h"

Tank::Tank(unsigned int id, unsigned int player_id, BlockPosition position,
	   const TerrainMap &map_, std::map<unsigned int, TeamablePtr> &game_objects,
	   float creation_mod) :
	Unit(id, player_id, CONFIGS.TANK_HP, position, map_, game_objects,
	     CONFIGS.TANK_CREATION_TIME / creation_mod){}

unsigned int Tank::get_class_id() const
{
	return CONFIGS.VEHICLE_CLASS_ID;
}

unsigned int Tank::get_type_id() const
{
	return CONFIGS.TANK_ID;
}

unsigned int Tank::get_weapon_id() const
{
	return this->cannon.get_weapon_id();
}

unsigned int Tank::get_range() const
{
	return CONFIGS.TANK_RANGE;
}

Tank::~Tank() = default;

const UnitMobility &Tank::get_mobility() const
{
	return this->mob;
}

bool Tank::can_traverse(BlockTerrain terrain) const
{
	return this->mob.can_traverse(terrain);
}

unsigned int Tank::traverse_time(BlockTerrain terrain) const
{
	if (terrain == dunes)
		return 2 * CONFIGS.TANK_TRAVERSE_TIME;
	else
		return CONFIGS.TANK_TRAVERSE_TIME;
}

Weapon &Tank::get_weapon()
{
	return this->cannon;
}