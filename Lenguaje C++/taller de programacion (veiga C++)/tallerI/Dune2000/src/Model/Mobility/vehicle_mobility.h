//
// Created by ignat on 13/06/22.
//

#ifndef DUNE2000_VEHICLE_MOBILITY_H
#define DUNE2000_VEHICLE_MOBILITY_H

#include "unit_mobility.h"

class VehicleMobility : public UnitMobility {
	public:
	virtual bool can_traverse(BlockTerrain terrain) const override;
};

#endif //DUNE2000_VEHICLE_MOBILITY_H
