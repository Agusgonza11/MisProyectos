//
// Created by ignat on 10/06/22.
//

#ifndef DUNE2000_WEAPON_H
#define DUNE2000_WEAPON_H

class Weapon {
	unsigned int dmg;
	/*
	 * en milisegundos
	 */
	unsigned int recharge_time;
	unsigned int timer;

	public:
	Weapon(unsigned int damage, unsigned int recharge_time_);

	unsigned int damage(unsigned int target_class_id, unsigned int time_passed);

	virtual unsigned int bonus_damage(unsigned int target_class_id) const = 0;

	virtual unsigned int get_weapon_id() const = 0;

	virtual ~Weapon();

	private:
	void update_timer(unsigned int time);
};

#endif //DUNE2000_WEAPON_H
