//
// Created by ignat on 13/06/22.
//

#ifndef DUNE2000_CANNON_H
#define DUNE2000_CANNON_H

#include "weapon.h"

class Cannon : public Weapon {
public:
	Cannon();

	virtual unsigned int bonus_damage(unsigned int target_class_id) const override;

	virtual unsigned int get_weapon_id() const override;

	virtual ~Cannon();
};

#endif //DUNE2000_CANNON_H
