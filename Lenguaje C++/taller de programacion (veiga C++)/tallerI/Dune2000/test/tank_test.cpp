//
// Created by ignat on 12/06/22.
//

#include "acutest.h"
#include "../src/Model/Entities/tank.h"
#include "../src/Model/configurations.h"

typedef std::shared_ptr<Unit> UnitPtr;

void test_create(void)
{
	TerrainMap map(4, 5);
	std::map<unsigned int, TeamablePtr> game_objects;
	Tank tank(1, 2, BlockPosition(3, 0), map, game_objects, 1);
	TEST_CHECK(tank.get_id() == 1);
	TEST_CHECK(tank.get_player_id() == 2);
	TEST_CHECK(tank.get_class_id() == CONFIGS.VEHICLE_CLASS_ID); // vehiculos
	TEST_CHECK(tank.get_type_id() == CONFIGS.TANK_ID); // tanque
	TEST_CHECK(tank.get_state() == creating);
	TEST_CHECK(not tank.is_movable());
	TEST_CHECK(not tank.can_attack());
	tank.update(CONFIGS.TANK_CREATION_TIME); // 4 minutos
	TEST_CHECK(tank.get_state() == neutral);
	TEST_CHECK(tank.is_movable());
	TEST_CHECK(tank.can_attack());
	TEST_CHECK(tank.get_hp() == CONFIGS.TANK_HP);
	TEST_CHECK(tank.get_weapon_id() == CONFIGS.CANNON_ID); // cañon
	TEST_CHECK(tank.get_position() == BlockPosition(3, 0));
	TEST_CHECK(tank.facing_position() == BlockPosition(3, 0));
	TEST_CHECK(tank.target_id() == 0);
}

void test_create_faster(void)
{
	TerrainMap map(4, 5);
	std::map<unsigned int, TeamablePtr> game_objects;
	Tank tank(1, 2, BlockPosition(3, 0), map, game_objects, 2);
	TEST_CHECK(tank.get_state() == creating);
	tank.update(CONFIGS.TANK_CREATION_TIME / 2);
	TEST_CHECK(tank.get_state() == neutral);
}

void test_create_slower(void)
{
	TerrainMap map(4, 5);
	std::map<unsigned int, TeamablePtr> game_objects;
	Tank tank(1, 2, BlockPosition(3, 0), map, game_objects, 0.5);
	TEST_CHECK(tank.get_state() == creating);
	tank.update(CONFIGS.TANK_CREATION_TIME);
	TEST_CHECK(tank.get_state() == creating);
	tank.update(CONFIGS.TANK_CREATION_TIME);
	TEST_CHECK(tank.get_state() == neutral);
}

void test_reduce_hp(void)
{
	TerrainMap map(4, 5);
	std::map<unsigned int, TeamablePtr> game_objects;
	Tank tank(1, 2, BlockPosition(3, 0), map, game_objects, 1);
	tank.update(CONFIGS.TANK_CREATION_TIME);
	TEST_CHECK(not tank.is_dead());
	tank.reduce_hp(20);
	TEST_CHECK(tank.get_hp() == CONFIGS.TANK_HP - 20);
	tank.reduce_hp(CONFIGS.TANK_HP - 20);
	TEST_CHECK(tank.is_dead());
}

void test_move_diagonal(void)
{
	TerrainMap map(4, 5);
	std::map<unsigned int, TeamablePtr> game_objects;
	BlockPosition org(3, 0);
	BlockPosition dst(1, 2);
	Tank tank(1, 2, org, map, game_objects, 1);
	tank.update(CONFIGS.TANK_CREATION_TIME);
	tank.move_to(dst);
	TEST_CHECK(tank.get_state() == moving);
	TEST_CHECK(tank.get_position() == org);

	tank.update(0);
	TEST_CHECK(not tank.changed_position());
	TEST_CHECK(tank.get_position() == org);

	tank.update(CONFIGS.TANK_TRAVERSE_TIME); // tanque hace un bloque cada 200ms
	TEST_CHECK(tank.changed_position());
	TEST_CHECK(tank.get_position() == BlockPosition(2, 1));

	tank.update(CONFIGS.TANK_TRAVERSE_TIME / 2);
	TEST_CHECK(not tank.changed_position());
	TEST_CHECK(tank.get_position() == BlockPosition(2, 1));

	tank.update(CONFIGS.TANK_TRAVERSE_TIME / 2);
	TEST_CHECK(tank.changed_position());
	TEST_CHECK(tank.get_position() == dst);
	TEST_CHECK(tank.get_state() == neutral);

	tank.update(CONFIGS.TANK_TRAVERSE_TIME);
	TEST_CHECK(not tank.changed_position());
	TEST_CHECK(tank.get_position() == dst);
	TEST_CHECK(tank.get_state() == neutral);
}

void test_move_through_dunes_slower(void)
{
	TerrainMap map(4, 5);
	map.change_terrain(BlockPosition(2, 1), dunes);
	std::map<unsigned int, TeamablePtr> game_objects;
	BlockPosition org(3, 0);
	BlockPosition dst(1, 2);
	Tank tank(1, 2, org, map, game_objects, 1);
	tank.update(CONFIGS.TANK_CREATION_TIME);
	tank.move_to(dst);

	tank.update(CONFIGS.TANK_TRAVERSE_TIME);
	TEST_CHECK(tank.changed_position());
	TEST_CHECK(tank.get_position() == BlockPosition(2, 1));

	tank.update(CONFIGS.TANK_TRAVERSE_TIME); // mitad de velocidad en las dunas
	TEST_CHECK(not tank.changed_position());
	TEST_CHECK(tank.get_position() == BlockPosition(2, 1));

	tank.update(CONFIGS.TANK_TRAVERSE_TIME);
	TEST_CHECK(tank.changed_position());
	TEST_CHECK(tank.get_position() == dst);
	TEST_CHECK(tank.get_state() == neutral);
}

void test_move_avoiding_obstacles(void)
{
	TerrainMap map(4, 5);
	map.change_terrain(BlockPosition(0, 1), cliffs);
	map.change_terrain(BlockPosition(0, 3), cliffs);
	map.change_terrain(BlockPosition(1, 3), cliffs);
	map.change_terrain(BlockPosition(2, 2), cliffs);
	map.change_terrain(BlockPosition(2, 1), peaks);
	map.change_terrain(BlockPosition(1, 1), cliffs);
	std::map<unsigned int, TeamablePtr> game_objects;
	BlockPosition org(3, 0);
	BlockPosition dst(1, 2);
	Tank tank(1, 2, org, map, game_objects, 1);
	tank.update(CONFIGS.TANK_CREATION_TIME);
	tank.move_to(dst);

	tank.update(CONFIGS.TANK_TRAVERSE_TIME);
	TEST_CHECK(tank.get_position() == BlockPosition(3, 1));
	tank.update(CONFIGS.TANK_TRAVERSE_TIME);
	TEST_CHECK(tank.get_position() == BlockPosition(3, 2));
	tank.update(CONFIGS.TANK_TRAVERSE_TIME);
	TEST_CHECK(tank.get_position() == BlockPosition(2, 3));
	tank.update(CONFIGS.TANK_TRAVERSE_TIME);
	TEST_CHECK(tank.get_position() == dst);
}

void test_neutral_no_enemies(void)
{
	TerrainMap map(4, 5);
	std::map<unsigned int, TeamablePtr> game_objects;
	UnitPtr tank1 = std::make_shared<Tank>(1, 2, BlockPosition(3, 0), map, game_objects, 1);
	UnitPtr tank2 = std::make_shared<Tank>(2, 2, BlockPosition(3, 1), map, game_objects, 1);
	game_objects.insert(std::pair<unsigned int, TeamablePtr>(tank1->get_id(), tank1));
	game_objects.insert(std::pair<unsigned int, TeamablePtr>(tank2->get_id(), tank2));
	tank1->update(CONFIGS.TANK_CREATION_TIME);
	tank2->update(CONFIGS.TANK_CREATION_TIME);
	TEST_CHECK(tank1->get_state() == neutral);
	TEST_CHECK(tank2->get_state() == neutral);
	tank1->update(0); // no ncesita pasar tiempo para setear un objetivo
	tank2->update(0);
	TEST_CHECK(tank1->get_state() == neutral);
	TEST_CHECK(tank2->get_state() == neutral);
	tank1->update(CONFIGS.CANNON_RECHARGE_TIME);
	tank2->update(CONFIGS.CANNON_RECHARGE_TIME);
	TEST_CHECK(tank1->get_hp() == CONFIGS.TANK_HP);
	TEST_CHECK(tank2->get_hp() == CONFIGS.TANK_HP);
}

void test_neutral_with_enemies(void)
{
	TerrainMap map(4, 5);
	std::map<unsigned int, TeamablePtr> game_objects;
	UnitPtr tank1 = std::make_shared<Tank>(1, 2, BlockPosition(3, 0), map, game_objects, 1);
	UnitPtr tank2 = std::make_shared<Tank>(2, 1, BlockPosition(3, 1), map, game_objects, 1);
	game_objects.insert(std::pair<unsigned int, TeamablePtr>(tank1->get_id(), tank1));
	game_objects.insert(std::pair<unsigned int, TeamablePtr>(tank2->get_id(), tank2));
	tank1->update(CONFIGS.TANK_CREATION_TIME);
	tank2->update(CONFIGS.TANK_CREATION_TIME);
	TEST_CHECK(tank1->get_state() == neutral);
	TEST_CHECK(tank2->get_state() == neutral);
	tank1->update(0); // no ncesita pasar tiempo para setear un objetivo
	tank2->update(0);
	TEST_CHECK(tank1->get_state() == autoattacking);
	TEST_CHECK(tank1->target_id() == 2);
	TEST_CHECK(tank2->get_state() == autoattacking);
	TEST_CHECK(tank2->target_id() == 1);
	tank1->update(CONFIGS.CANNON_RECHARGE_TIME); // tanque dispara 1 x segundo
	tank2->update(CONFIGS.CANNON_RECHARGE_TIME);
	TEST_CHECK(tank1->get_hp() == CONFIGS.TANK_HP - CONFIGS.CANNON_DMG); // daño del cañon es 7
	TEST_CHECK(tank2->get_hp() == CONFIGS.TANK_HP - CONFIGS.CANNON_DMG);
}

void test_neutral_loses_target(void)
{
	TerrainMap map(4, 5);
	std::map<unsigned int, TeamablePtr> game_objects;
	UnitPtr tank1 = std::make_shared<Tank>(1, 2, BlockPosition(3, 0), map, game_objects, 1);
	UnitPtr tank2 = std::make_shared<Tank>(2, 1, BlockPosition(2, 3), map, game_objects, 1);
	game_objects.insert(std::pair<unsigned int, TeamablePtr>(tank1->get_id(), tank1));
	game_objects.insert(std::pair<unsigned int, TeamablePtr>(tank2->get_id(), tank2));
	tank1->update(CONFIGS.TANK_CREATION_TIME);
	tank2->update(CONFIGS.TANK_CREATION_TIME);
	TEST_CHECK(tank1->get_state() == neutral);
	TEST_CHECK(tank2->get_state() == neutral);
	tank1->update(0);
	tank2->update(0);
	TEST_CHECK(tank1->get_state() == autoattacking);
	TEST_CHECK(tank2->get_state() == autoattacking);
	tank2->move_to(BlockPosition(2, 4));
	TEST_CHECK(tank1->get_state() == autoattacking);
	TEST_CHECK(tank2->get_state() == moving);
	tank1->update(CONFIGS.TANK_TRAVERSE_TIME);
	TEST_CHECK(tank1->get_state() == autoattacking);
	TEST_CHECK(tank2->get_hp() == 30); // todavia no ataco a tank2
	tank2->update(CONFIGS.TANK_TRAVERSE_TIME); // tanque 2 se mueve fuera del rango
	TEST_CHECK(tank2->get_position() == BlockPosition(2, 4));
	tank1->update(CONFIGS.CANNON_RECHARGE_TIME - CONFIGS.TANK_TRAVERSE_TIME); // recharge time > traverse time
	tank2->update(CONFIGS.CANNON_RECHARGE_TIME - CONFIGS.TANK_TRAVERSE_TIME);
	TEST_CHECK(tank1->get_hp() == CONFIGS.TANK_HP);
	TEST_CHECK(tank2->get_hp() == CONFIGS.TANK_HP);
	TEST_CHECK(tank1->get_state() == neutral);
	TEST_CHECK(tank2->get_state() == neutral);
}

void test_attack_still_target(void)
{
	TerrainMap map(4, 5);
	std::map<unsigned int, TeamablePtr> game_objects;
	UnitPtr tank1 = std::make_shared<Tank>(1, 2, BlockPosition(3, 0), map, game_objects, 1);
	UnitPtr tank2 = std::make_shared<Tank>(2, 1, BlockPosition(0, 3), map, game_objects, 1);
	game_objects.insert(std::pair<unsigned int, TeamablePtr>(tank1->get_id(), tank1));
	game_objects.insert(std::pair<unsigned int, TeamablePtr>(tank2->get_id(), tank2));
	tank1->update(CONFIGS.TANK_CREATION_TIME);
	tank2->update(CONFIGS.TANK_CREATION_TIME);
	tank1->attack(2); // notar que tank2 esta fuera de rango. tank1 tiene que acercarse
	TEST_CHECK(tank1->target_id() == 2);
	TEST_CHECK(tank1->get_state() == chasing);
	tank1->update(CONFIGS.TANK_TRAVERSE_TIME - 1);
	TEST_CHECK(tank1->get_position() == BlockPosition(3, 0));
	TEST_CHECK(tank1->get_state() == chasing);
	tank1->update(1);
	TEST_CHECK(tank1->get_position() == BlockPosition(2, 0)
	or tank1->get_position() == BlockPosition(3, 1));
	TEST_CHECK(tank1->get_state() == attacking);
	tank1->update(CONFIGS.CANNON_RECHARGE_TIME);
	TEST_CHECK(tank2->get_hp() == CONFIGS.TANK_HP - CONFIGS.CANNON_DMG);
}

void test_attack_and_chase(void)
{
	TerrainMap map(4, 5);
	std::map<unsigned int, TeamablePtr> game_objects;
	UnitPtr tank1 = std::make_shared<Tank>(1, 2, BlockPosition(3, 0), map, game_objects, 1);
	UnitPtr tank2 = std::make_shared<Tank>(2, 1, BlockPosition(1, 2), map, game_objects, 1);
	game_objects.insert(std::pair<unsigned int, TeamablePtr>(tank1->get_id(), tank1));
	game_objects.insert(std::pair<unsigned int, TeamablePtr>(tank2->get_id(), tank2));
	tank1->update(CONFIGS.TANK_CREATION_TIME);
	tank2->update(CONFIGS.TANK_CREATION_TIME);
	tank1->attack(2);
	tank2->move_to(BlockPosition(0, 3));
	TEST_CHECK(tank1->get_state() == attacking);
	TEST_CHECK(tank2->get_state() == moving);
	tank1->update(CONFIGS.TANK_TRAVERSE_TIME); // tank1 usa estos 200ms para recargar el arma
	tank2->update(CONFIGS.TANK_TRAVERSE_TIME); // tank2 se mueve
	TEST_CHECK(tank2->changed_position());
	TEST_CHECK(tank2->get_position() == BlockPosition(0, 3));
	tank1->update(0);
	tank2->update(0);
	TEST_CHECK(tank1->get_state() == chasing);
	tank1->update(CONFIGS.TANK_TRAVERSE_TIME);
	TEST_CHECK(tank1->get_position() == BlockPosition(2, 0)
	or tank1->get_position() == BlockPosition(3, 1));
	TEST_CHECK(tank1->get_state() == attacking);
	tank1->update(CONFIGS.CANNON_RECHARGE_TIME - CONFIGS.TANK_TRAVERSE_TIME);
	TEST_CHECK(tank2->get_hp() == CONFIGS.TANK_HP - CONFIGS.CANNON_DMG);
}


void test_target_dies(void)
{
	TerrainMap map(4, 5);
	std::map<unsigned int, TeamablePtr> game_objects;
	UnitPtr tank1 = std::make_shared<Tank>(1, 2, BlockPosition(3, 0), map, game_objects, 1);
	UnitPtr tank2 = std::make_shared<Tank>(2, 1, BlockPosition(1, 2), map, game_objects, 1);
	game_objects.insert(std::pair<unsigned int, TeamablePtr>(tank1->get_id(), tank1));
	game_objects.insert(std::pair<unsigned int, TeamablePtr>(tank2->get_id(), tank2));
	tank1->update(CONFIGS.TANK_CREATION_TIME);
	tank2->update(CONFIGS.TANK_CREATION_TIME);
	tank1->attack(2);
	// este test puede fallar si se modifica el daño del cañon
	for (unsigned int i = 1; i <= 4; i++) {
		tank1->update(CONFIGS.CANNON_RECHARGE_TIME);
		TEST_CHECK(tank2->get_hp() == 30 - CONFIGS.CANNON_DMG * i);
	}
	tank1->update(CONFIGS.CANNON_RECHARGE_TIME);
	TEST_CHECK(tank2->is_dead());
	TEST_CHECK(tank1->get_state() == attacking);
	tank1->update(0);
	TEST_CHECK(tank1->get_state() == neutral);
}

void test_cannot_attack_target_creating(void)
{
	TerrainMap map(4, 5);
	std::map<unsigned int, TeamablePtr> game_objects;
	UnitPtr tank1 = std::make_shared<Tank>(1, 2, BlockPosition(3, 0), map, game_objects, 1);
	UnitPtr tank2 = std::make_shared<Tank>(2, 1, BlockPosition(1, 2), map, game_objects, 1);
	game_objects.insert(std::pair<unsigned int, TeamablePtr>(tank1->get_id(), tank1));
	game_objects.insert(std::pair<unsigned int, TeamablePtr>(tank2->get_id(), tank2));
	tank1->update(CONFIGS.TANK_CREATION_TIME);
	tank1->update(0);
	TEST_CHECK(tank1->get_state() == neutral);
	tank1->attack(2);
	TEST_CHECK(tank1->get_state() == neutral);
}

TEST_LIST = {
	{"create", test_create},
	{"create_faster", test_create_faster},
	{"create_slower", test_create_slower},
	{"reduce_hp", test_reduce_hp},
	{"move_diagonal", test_move_diagonal},
	{"move_dunes", test_move_through_dunes_slower},
	{"move_with_obstacles", test_move_avoiding_obstacles},
	{"neutral_no_enemies", test_neutral_no_enemies},
	{"neutral_with_enemies", test_neutral_with_enemies},
	{"neutral_lose_target", test_neutral_loses_target},
	{"attack_still_target", test_attack_still_target},
	{"attack_and_chase", test_attack_and_chase},
	{"kill_target", test_target_dies},
	{"creating_invulnerable", test_cannot_attack_target_creating},
	{NULL, NULL}
};