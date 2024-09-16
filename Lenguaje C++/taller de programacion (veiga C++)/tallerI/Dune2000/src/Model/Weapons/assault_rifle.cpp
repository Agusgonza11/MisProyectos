//
// Created by ignat on 10/06/22.
//

#include "assault_rifle.h"
#include "../configurations.h"

AssaultRifle::AssaultRifle() :
	Weapon(CONFIGS.ASSAULT_RIFLE_DMG, CONFIGS.ASSAULT_RIFLE_RECHARGE_TIME){}

unsigned int AssaultRifle::bonus_damage(unsigned int target_class_id) const
{
	if (target_class_id == 1)
		return CONFIGS.ASSAULT_RIFLE_BONUS;
	else
		return 0;
}

unsigned int AssaultRifle::get_weapon_id() const
{
	return CONFIGS.ASSAULT_RIFLE_ID;
}

AssaultRifle::~AssaultRifle() = default;
