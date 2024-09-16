//
// Created by ignat on 19/05/22.
//

#ifndef DUNE2000_INFANTRY_MOBILITY_H
#define DUNE2000_INFANTRY_MOBILITY_H

#include "./unit_mobility.h"

class InfantryMobility : public UnitMobility {
	public:
	virtual bool can_traverse(BlockTerrain terrain) const override;
};

#endif //DUNE2000_INFANTRY_MOBILITY_H
