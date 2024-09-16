//
// Created by ignat on 30/05/22.
//

#ifndef DUNE2000_CONTROL_UNIT_H
#define DUNE2000_CONTROL_UNIT_H

#include "../Model/Map/terrain_map.h"
#include "../Model/Entities/teamable.h"
#include "entity_factory.h"
#include <vector>
#include <map>
#include <memory>

using namespace std;
typedef vector<pair<BlockPosition, BlockTerrain>> Terrains;

class ControlUnit {
	TerrainMap map;

	std::map<unsigned int, shared_ptr<Teamable>> entities;

	EntityFactory factory;

	public:
	ControlUnit(unsigned int rows, unsigned int cols);

	void set_terrains(const Terrains &terrains);

	unsigned int units_count() const;

	void cmd_create(unsigned int player_id, unsigned int type_id, BlockPosition position);
	void cmd_move(int id, BlockPosition destination);
	void cmd_attack(unsigned int id, unsigned int target_id);

	void update(unsigned int time_delta);

	std::vector<shared_ptr<Teamable>> get_state() const;

	~ControlUnit();
};

#endif //DUNE2000_CONTROL_UNIT_H
