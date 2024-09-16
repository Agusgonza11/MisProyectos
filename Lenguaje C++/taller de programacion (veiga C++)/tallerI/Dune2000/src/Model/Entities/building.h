//
// Created by ignat on 18/06/22.
//

#ifndef DUNE2000_BUILDING_H
#define DUNE2000_BUILDING_H

#include "teamable.h"

class Building : public Teamable {
	BlockPosition pos; // posicion superior izquierda
	unsigned int width; // tamaño horizontal
	unsigned int length; // tamaño vertical
	unsigned int energy;

public:
	Building(unsigned int id, unsigned int player_id, unsigned int hp,
		 BlockPosition pos_, unsigned int width_, unsigned int length_,
		 unsigned int energy_consumption);

	virtual bool is_movable() const override;
	virtual bool can_attack() const override;
	virtual bool is_damageable() const override;

	virtual bool changed_position() const override;
	virtual double distance_to(BlockPosition position) const override;
	virtual std::vector<BlockPosition> positions_at_range(unsigned short int range) const override;
	std::vector<BlockPosition> occupied_space() const;
	unsigned int energy_consumed() const;

	virtual unsigned int get_class_id() const override;
	virtual unsigned int get_type_id() const = 0;

	virtual ~Building();
};

#endif //DUNE2000_BUILDING_H
