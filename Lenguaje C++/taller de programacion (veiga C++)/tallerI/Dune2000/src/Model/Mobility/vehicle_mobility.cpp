//
// Created by ignat on 13/06/22.
//

#include "vehicle_mobility.h"

bool VehicleMobility::can_traverse(BlockTerrain terrain) const
{
	return terrain != peaks and terrain != cliffs and terrain != construction;
}
