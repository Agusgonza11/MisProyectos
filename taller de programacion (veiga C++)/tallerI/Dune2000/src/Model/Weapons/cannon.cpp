//
// Created by ignat on 13/06/22.
//

#include "cannon.h"
#include "../configurations.h"

Cannon::Cannon() :
	Weapon(CONFIGS.CANNON_DMG, CONFIGS.CANNON_RECHARGE_TIME){}

unsigned int Cannon::bonus_damage(unsigned int target_class_id) const
{
	return CONFIGS.CANNON_BONUS;
}

unsigned int Cannon::get_weapon_id() const
{
	return CONFIGS.CANNON_ID;
}

Cannon::~Cannon() = default;