//
// Created by ignat on 19/05/22.
//

#include "./infantry_mobility.h"

bool InfantryMobility::can_traverse(BlockTerrain terrain) const
{
	return terrain != cliffs;
}