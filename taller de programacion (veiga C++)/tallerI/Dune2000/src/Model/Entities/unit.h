//
// Created by ignat on 13/06/22.
//

#ifndef DUNE2000_UNIT_H
#define DUNE2000_UNIT_H

#include "teamable.h"
#include "../Map/terrain_map.h"
#include "../Weapons/weapon.h"
#include <map>
#include <memory>

typedef std::shared_ptr<Teamable> TeamablePtr;

enum UnitState {
	creating,
	neutral,
	autoattacking,
	moving,
	attacking,
	chasing
};

class Unit : public Teamable {
	BlockPosition pos;
	const TerrainMap &map;
	std::map<unsigned int, TeamablePtr> &game_objects;
	UnitState state;
	// tiempo - en ms
	unsigned int creat_time;
	// atributos que dependen del estado
	unsigned int timer; // timer para saber cuando moverse
	std::vector<BlockPosition> path;
	bool changed_pos;
	TeamablePtr target;

public:
	Unit(unsigned int id, unsigned int player_id, unsigned int start_hp,
	     BlockPosition position, const TerrainMap &map_,
	     std::map<unsigned int, TeamablePtr> &game_objects_,
	     unsigned int creation_time);

	virtual bool is_movable() const override;
	virtual bool can_attack() const override;
	virtual bool is_damageable() const override;
	virtual bool can_traverse(BlockTerrain terrain) const = 0;

	void update(unsigned int time_delta);

	void move_to(BlockPosition destination);
	void attack(unsigned int target_id);

	BlockPosition facing_position() const;
	virtual bool changed_position() const override;
	virtual double distance_to(BlockPosition position) const override;
	virtual std::vector<BlockPosition> positions_at_range(unsigned short int range) const override;
	unsigned int target_id() const;

	// getters
	BlockPosition get_position() const;
	UnitState get_state() const;
	virtual unsigned int get_class_id() const = 0;
	virtual unsigned int get_type_id() const = 0;
	virtual unsigned int get_weapon_id() const = 0;
	virtual unsigned int get_range() const = 0;

	virtual ~Unit();

protected:
	virtual const UnitMobility &get_mobility() const = 0;
	virtual unsigned int traverse_time(BlockTerrain terrain) const = 0;
	virtual Weapon &get_weapon() = 0;

private:
	void update_timer(unsigned int time_delta);
	void act_creating(unsigned int time_delta);
	void act_neutral(unsigned int time_delta);
	void act_autoattacking(unsigned int time_delta);
	void act_moving(unsigned int time_delta);
	void act_attacking(unsigned int time_delta);
	void act_chasing(unsigned int time_delta);

	void reset_state();
	void reset_path();
	void reset_target();
};

#endif //DUNE2000_UNIT_H
