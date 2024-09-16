//
// Created by ignat on 16/06/22.
//

#include "entity_factory.h"
#include "../Model/configurations.h"
#include "../Model/Entities/light_infantry.h"
#include "../Model/Entities/tank.h"
#include "../Model/Entities/trike.h"

EntityFactory::EntityFactory(TerrainMap &cu_map, std::map<unsigned int, TeamablePtr> &cu_entities) :
	map(cu_map),
	entities(cu_entities),
	id_counter(1){}

void EntityFactory::create(unsigned int player_id, unsigned int type_id, BlockPosition position)
{
	if (this->map.invalid_position(position))
		return;

	if (type_id == CONFIGS.L_INFANTRY_ID)
		this->mk_linfantry(player_id, position);
	else if (type_id == CONFIGS.TANK_ID)
		this->mk_tank(player_id, position);
	else if (type_id == CONFIGS.TRIKE_ID)
		this->mk_trike(player_id, position);
}

EntityFactory::~EntityFactory() = default;

void EntityFactory::mk_linfantry(unsigned int player_id, BlockPosition position)
{
	std::shared_ptr<LightInfantry> ptr = std::make_shared<LightInfantry>(this->id_counter, player_id,
									     position, this->map,
									     this->entities, 1);
	if (ptr->can_traverse(this->map.at(position))) {
		this->entities.insert(std::pair<unsigned int, TeamablePtr>(ptr->get_id(), ptr));
		this->id_counter++;
	}
}

void EntityFactory::mk_tank(unsigned int player_id, BlockPosition position)
{
	std::shared_ptr<Tank> ptr = std::make_shared<Tank>(this->id_counter, player_id,
							   position, this->map,
							   this->entities, 1);

	if (ptr->can_traverse(this->map.at(position))) {
		this->entities.insert(std::pair<unsigned int, TeamablePtr>(ptr->get_id(), ptr));
		this->id_counter++;
	}
}

void EntityFactory::mk_trike(unsigned int player_id, BlockPosition position)
{
	std::shared_ptr<Trike> ptr = std::make_shared<Trike>(this->id_counter, player_id,
	                                                   position, this->map,
	                                                   this->entities, 1);

	if (ptr->can_traverse(this->map.at(position))) {
		this->entities.insert(std::pair<unsigned int, TeamablePtr>(ptr->get_id(), ptr));
		this->id_counter++;
	}
}