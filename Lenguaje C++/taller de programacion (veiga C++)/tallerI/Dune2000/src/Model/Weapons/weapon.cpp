//
// Created by ignat on 10/06/22.
//

#include "weapon.h"

Weapon::Weapon(unsigned int damage, unsigned int recharge_time_) :
	dmg(damage),
	recharge_time(recharge_time_),
	timer(recharge_time_){}

unsigned int Weapon::damage(unsigned int target_class_id, unsigned int time_passed)
{
	this->update_timer(time_passed);

	if (this->timer == 0) {
		this->timer = this->recharge_time;
		return this->dmg + this->bonus_damage(target_class_id);
	} else {
		return 0;
	}
}

void Weapon::update_timer(unsigned int time)
{
	if (this->timer > time)
		this->timer -= time;
	else
		this->timer = 0;
}

Weapon::~Weapon() = default;
