//
// Created by ignat on 09/06/22.
//

#ifndef DUNE2000_TEAMABLE_H
#define DUNE2000_TEAMABLE_H

#include "../Map/block_position.h"
#include <vector>

const unsigned int INVALID_ID = 0;

class Teamable {
	unsigned int id;
	unsigned int player_id;
	unsigned int hp;

	public:
	Teamable(unsigned int id_, unsigned int player_id_, unsigned int start_hp);

	virtual bool is_movable() const = 0;
	virtual bool can_attack() const = 0;
	virtual bool is_damageable() const = 0;

	void reduce_hp(unsigned int dmg);
	void destroy();
	bool is_dead() const;

	virtual bool changed_position() const = 0;
	virtual double distance_to(BlockPosition position) const = 0;
	virtual std::vector<BlockPosition> positions_at_range(unsigned short int range) const = 0;


	unsigned int get_id() const;
	unsigned int get_player_id() const;
	unsigned int get_hp() const;
	virtual unsigned int get_class_id() const = 0;
	virtual unsigned int get_type_id() const = 0;

	virtual ~Teamable();

	/*
	 * Teamable no es copiable
	 */
	Teamable(const Teamable &other) = delete;
	Teamable &operator=(const Teamable &other) = delete;

	/*
	 * Teamable no es movible
	 */
	Teamable(Teamable &&other) = delete;
	Teamable &operator=(Teamable &&other) = delete;
};

#endif //DUNE2000_TEAMABLE_H
