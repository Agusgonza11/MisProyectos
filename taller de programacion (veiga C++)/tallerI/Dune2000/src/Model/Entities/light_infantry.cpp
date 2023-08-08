//
// Created by ignat on 10/06/22.
//

#include "light_infantry.h"
#include "../configurations.h"


LightInfantry::LightInfantry(unsigned int id, unsigned int player_id, BlockPosition position,
			     const TerrainMap &map_, std::map<unsigned int, TeamablePtr> &game_objects,
			     float creation_mod) :
	Unit(id, player_id, CONFIGS.L_INFANTRY_HP, position, map_, game_objects,
	     CONFIGS.L_INFANTRY_CREATION_TIME / creation_mod){}

unsigned int LightInfantry::get_class_id() const
{
	return CONFIGS.INFANTRY_CLASS_ID;
}

unsigned int LightInfantry::get_type_id() const
{
	return CONFIGS.L_INFANTRY_ID;
}

unsigned int LightInfantry::get_weapon_id() const
{
	return this->rifle.get_weapon_id();
}

unsigned int LightInfantry::get_range() const
{
	return CONFIGS.L_INFANTRY_RANGE;
}

LightInfantry::~LightInfantry() = default;

const UnitMobility &LightInfantry::get_mobility() const
{
	return this->mob;
}

bool LightInfantry::can_traverse(BlockTerrain terrain) const
{
	return this->mob.can_traverse(terrain);
}

unsigned int LightInfantry::traverse_time(BlockTerrain terrain) const
{
	if (terrain == dunes)
		return 2 * CONFIGS.L_INFANTRY_TRAVERSE_TIME;
	else
		return CONFIGS.L_INFANTRY_TRAVERSE_TIME;
}

Weapon &LightInfantry::get_weapon()
{
	return this->rifle;
}