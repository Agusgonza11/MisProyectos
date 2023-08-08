//
// Created by ignat on 18/06/22.
//

#ifndef DUNE2000_CONSTRUCTION_CENTRE_H
#define DUNE2000_CONSTRUCTION_CENTRE_H

#include "building.h"

class ConstructionCentre : public Building {
public:
	ConstructionCentre(unsigned int id, unsigned int player_id, BlockPosition position);

	virtual unsigned int get_type_id() const override;

	virtual ~ConstructionCentre();
};

#endif //DUNE2000_CONSTRUCTION_CENTRE_H
