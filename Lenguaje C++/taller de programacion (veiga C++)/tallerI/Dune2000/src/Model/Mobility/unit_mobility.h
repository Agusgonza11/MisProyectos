//
// Created by ignat on 19/05/22.
//

#ifndef DUNE2000_UNIT_MOBILITY_H
#define DUNE2000_UNIT_MOBILITY_H

#include "../Map/block_terrain.h"

class UnitMobility {
	public:
	virtual bool can_traverse(BlockTerrain terrain) const = 0;
};

#endif //DUNE2000_UNIT_MOBILITY_H
