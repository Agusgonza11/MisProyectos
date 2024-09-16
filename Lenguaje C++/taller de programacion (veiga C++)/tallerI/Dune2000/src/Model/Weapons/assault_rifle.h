//
// Created by ignat on 10/06/22.
//

#ifndef DUNE2000_ASSAULT_RIFLE_H
#define DUNE2000_ASSAULT_RIFLE_H

#include "weapon.h"

class AssaultRifle : public Weapon {
	public:
	AssaultRifle();

	virtual unsigned int bonus_damage(unsigned int target_class_id) const override;

	virtual unsigned int get_weapon_id() const override;

	virtual ~AssaultRifle();
};

#endif //DUNE2000_ASSAULT_RIFLE_H
