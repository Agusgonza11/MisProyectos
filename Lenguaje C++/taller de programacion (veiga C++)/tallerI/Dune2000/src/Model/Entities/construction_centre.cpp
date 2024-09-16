//
// Created by ignat on 18/06/22.
//

#include "construction_centre.h"
#include "../configurations.h"

ConstructionCentre::ConstructionCentre(unsigned int id, unsigned int player_id,
				       BlockPosition position) :
	Building(id, player_id, CONFIGS.CENTRE_HP, position,
		 CONFIGS.CENTRE_WIDTH, CONFIGS.CENTRE_LENGTH, CONFIGS.CENTRE_ENERGY){}

unsigned int ConstructionCentre::get_type_id() const
{
	return CONFIGS.CENTRE_ID;
}

ConstructionCentre::~ConstructionCentre() = default;
