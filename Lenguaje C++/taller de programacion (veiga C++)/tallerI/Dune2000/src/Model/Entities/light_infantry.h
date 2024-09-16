//
// Created by ignat on 10/06/22.
//

#ifndef DUNE2000_LIGHT_INFANTRY_H
#define DUNE2000_LIGHT_INFANTRY_H

#include "unit.h"
#include "../Mobility/infantry_mobility.h"
#include "../Weapons/assault_rifle.h"

class LightInfantry : public Unit {
	InfantryMobility mob;
	AssaultRifle rifle;

public:
	LightInfantry(unsigned int id, unsigned int player_id, BlockPosition position,
	     const TerrainMap &map_, std::map<unsigned int, TeamablePtr> &game_objects,
	     float creation_mod);

	virtual unsigned int get_class_id() const override;
	virtual unsigned int get_type_id() const override;
	virtual unsigned int get_weapon_id() const override;
	virtual unsigned int get_range() const override;

	virtual bool can_traverse(BlockTerrain terrain) const override;

	virtual ~LightInfantry();

protected:
	virtual const UnitMobility &get_mobility() const override;
	virtual unsigned int traverse_time(BlockTerrain terrain) const override;
	virtual Weapon &get_weapon() override;
};

#endif //DUNE2000_LIGHT_INFANTRY_H
