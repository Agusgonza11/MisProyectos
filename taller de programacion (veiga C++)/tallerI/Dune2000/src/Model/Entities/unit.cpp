//
// Created by ignat on 13/06/22.
//

#include "unit.h"

Unit::Unit(unsigned int id, unsigned int player_id, unsigned int start_hp,
	   BlockPosition position, const TerrainMap &map_,
	   std::map<unsigned int, TeamablePtr> &game_objects_,
	   unsigned int creation_time) :
	Teamable(id, player_id, start_hp),
	pos(position),
	map(map_),
	game_objects(game_objects_),
	state(creating),
	creat_time(creation_time),
	timer(creation_time),
	changed_pos(false),
	target(nullptr){}

void Unit::update(unsigned int time_delta)
{
	if (this->is_dead())
		return;

	if (this->state == creating)
		this->act_creating(time_delta);
	else if (this->state == neutral)
		this->act_neutral(time_delta);
	else if (this->state == autoattacking)
		this->act_autoattacking(time_delta);
	else if (this->state == moving)
		this->act_moving(time_delta);
	else if (this->state == attacking)
		this->act_attacking(time_delta);
	else if (this->state == chasing)
		this->act_chasing(time_delta);
}

void Unit::update_timer(unsigned int time_delta)
{
	if (this->timer <= time_delta)
		this->timer = 0;
	else
		this->timer -= time_delta;
}

void Unit::move_to(BlockPosition dst)
{
	if (this->state == creating)
		return; // no se puede hacer nada mientras se esta creando
	else
		this->reset_state(); // dar un comando resetea el estado

	if (this->map.invalid_position(dst))
		return;

	const UnitMobility &mob = this->get_mobility();
	this->path = this->map.get_path(this->pos, dst, mob);
	if (this->path.size() >= 2) {
		this->path.pop_back(); // La primer posicion es la posicion actual
		this->state = moving;
		this->timer = this->traverse_time(this->map.at(this->pos));
	} else {
		this->reset_path(); // solo para ahorrar un poco de memoria pero no es necesario al verdad
	}
}

void Unit::attack(unsigned int target_id)
{
	if (this->state == creating)
		return; // idem que para moverse
	else
		this->reset_state();

	if (this->game_objects.count(target_id) == 0)
		return;

	TeamablePtr tmp_target = this->game_objects.at(target_id);
	if (tmp_target->get_player_id() == this->get_player_id()
	or not tmp_target->is_damageable())
		return; // no ataca cosas que sean del mismo equipo o que no se puedan dañar

	if (tmp_target->distance_to(this->pos) <= this->get_range()) {
		this->target = tmp_target;
		this->state = attacking; // si esta en rango se pone a atacarlo directamente
	} else { // sino tiene que perseguirlo/acercase
		std::vector<BlockPosition> at_range = tmp_target->positions_at_range(this->get_range());
		if (at_range.empty())
			return; // creo que no se puede dar este caso pero por las dudas los pongo

		BlockPosition closest = at_range.front();
		for (auto const &it : at_range) {
			if (it.distance_to(this->pos) < closest.distance_to(this->pos))
				closest = it;
		}
		this->move_to(closest); // si no se puede mover a esa posicion, no intenta con otra
		if (this->state == moving) {
			this->state = chasing;
			this->target = tmp_target;
		}
	}
}

void Unit::act_creating(unsigned int time_delta)
{
	this->update_timer(time_delta);
	if (this->timer == 0)
		this->state = neutral;
}

void Unit::act_neutral(unsigned int time_delta)
{
	this->changed_pos = false;
	for (auto &it : this->game_objects) {
		TeamablePtr tmp = it.second;
		if (tmp->get_player_id() != this->get_player_id()
		and tmp->distance_to(this->pos) <= this->get_range()
		and tmp->is_damageable()) {
			this->target = tmp;
			this->state = autoattacking;
			return; // se pone a atacar al primero que encuentre en rango
		}
	}
}

void Unit::act_autoattacking(unsigned int time_delta)
{
	this->changed_pos = false;
	if (this->target->is_dead()) {
		this->reset_state();
		return;
	}
	if (this->target->distance_to(this->pos) <= this->get_range()) {
		Weapon &weapon = this->get_weapon();
		unsigned int dmg = weapon.damage(this->target->get_class_id(), time_delta);
		this->target->reduce_hp(dmg);
	} else {
		this->reset_state();
	}
}

void Unit::act_moving(unsigned int time_delta)
{
	this->update_timer(time_delta);
	if (this->timer > 0) {
		this->changed_pos = false;
		return;
	}

	BlockPosition next_pos = this->path.back();
	if (this->can_traverse(this->map.at(next_pos))) {
		this->pos = next_pos;
		this->changed_pos = true;
		this->path.pop_back();
		if (this->path.empty())
			this->state = neutral;
		else
			this->timer = this->traverse_time(this->map.at(this->pos));
	} else {
		this->changed_pos = false;
		this->reset_state();
	}
}

void Unit::act_attacking(unsigned int time_delta)
{
	this->changed_pos = false;
	if (this->target->is_dead()) {
		this->reset_state();
		return;
	}
	if (this->target->distance_to(this->pos) <= this->get_range()) {
		Weapon &weapon = this->get_weapon();
		unsigned int dmg = weapon.damage(this->target->get_class_id(), time_delta);
		this->target->reduce_hp(dmg);
	} else {
		this->attack(this->target->get_id()); // recalcular el ataque, se podria optimizar
	}
}

void Unit::act_chasing(unsigned int time_delta)
{
	this->changed_pos = false;
	if (this->target->is_dead()) {
		this->reset_state();
		return;
	}
	if (this->target->changed_position()) {
		this->attack(this->target->get_id());
	} else {
		this->act_moving(time_delta);
		if (not this->changed_pos and this->state == neutral) { // no se pudo mover
			this->reset_state();
			return;
		}
		if (this->state == neutral) // llego a destino
			this->state = attacking;
	}
}

BlockPosition Unit::facing_position() const
{
	if (this->state == moving or this->state == chasing)
		return this->path.back();
	else
		return this->pos;
}

bool Unit::changed_position() const
{
	return this->changed_pos;
}

double Unit::distance_to(BlockPosition position) const
{
	return this->pos.distance_to(position);
}

std::vector <BlockPosition> Unit::positions_at_range(unsigned short range) const
{
	std::vector<BlockPosition> positions;
	unsigned int row = this->pos.row();
	unsigned int col = this->pos.col();

	int x, y;
	for (x = -range; x <= range; x++) {
		for (y = -range; y <= range; y++) {
			BlockPosition position(row + x, col + y);
			if (not this->map.invalid_position(position)
			    and this->pos.distance_to(position) <= range)
				positions.push_back(position);
		}
	}

	return positions;
}

unsigned int Unit::target_id() const
{
	if (this->target.get() == nullptr)
		return 0;
	else
		return this->target->get_id();
}

bool Unit::is_movable() const
{
	return this->state != creating;
}

bool Unit::can_attack() const
{
	return this->state != creating;
}

bool Unit::is_damageable() const
{
	return this->state != creating;
}

BlockPosition Unit::get_position() const
{
	return this->pos;
}

UnitState Unit::get_state() const
{
	return this->state;
}

void Unit::reset_state()
{
	this->state = neutral;
	this->reset_path();
	this->reset_target();
}

void Unit::reset_path()
{
	this->path = std::vector<BlockPosition>();
}

void Unit::reset_target()
{
	this->target = TeamablePtr(nullptr);
}

Unit::~Unit() = default;