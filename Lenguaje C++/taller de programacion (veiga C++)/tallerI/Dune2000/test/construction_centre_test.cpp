//
// Created by ignat on 18/06/22.
//

#include "acutest.h"
#include "../src/Model/Entities/construction_centre.h"
#include "../src/Model/configurations.h"
#include <algorithm>

void test_create(void)
{
	ConstructionCentre centre(1, 2, BlockPosition(0, 0));
	TEST_CHECK(not centre.is_movable());
	TEST_CHECK(not centre.can_attack());
	TEST_CHECK(centre.is_damageable());
	TEST_CHECK(centre.get_hp() == CONFIGS.CENTRE_HP);
	TEST_CHECK(centre.energy_consumed() == CONFIGS.CENTRE_ENERGY);
	TEST_CHECK(centre.get_class_id() == CONFIGS.BUILDING_CLASS_ID);
	TEST_CHECK(centre.get_type_id() == CONFIGS.CENTRE_ID);
}

void test_distance(void)
{
	ConstructionCentre centre(1, 2, BlockPosition(0, 0));
	BlockPosition pos1(2, 2);
	BlockPosition pos2(2, 3);
	BlockPosition pos3(3, 3);

	TEST_CHECK(centre.distance_to(pos1) == 0);
	TEST_CHECK(centre.distance_to(pos2) == 1);
	TEST_CHECK(centre.distance_to(pos3) == pos1.distance_to(pos3));
}

void test_positions_at_range(void)
{
	ConstructionCentre centre(1, 2, BlockPosition(0, 0));
	std::vector<BlockPosition> at_range = centre.positions_at_range(1);
	TEST_CHECK(at_range.size() == 15); // tambien cuenta las posiciones que ocupa
	TEST_MSG("Size1: %lu", at_range.size());
	at_range = centre.positions_at_range(2);
	TEST_CHECK(at_range.size() == 22);
}

void test_occupied_space(void)
{
	ConstructionCentre centre(1, 2, BlockPosition(1, 2));
	std::vector<BlockPosition> space = centre.occupied_space();

	TEST_CHECK(space.size() == 9);
	auto it = std::find(space.begin(), space.end(), BlockPosition(1, 2));
	TEST_CHECK(it != space.end());
	it = std::find(space.begin(), space.end(), BlockPosition(3, 4));
	TEST_CHECK(it != space.end());
}

TEST_LIST = {
	{"create", test_create},
	{"distance", test_distance},
	{"at_range", test_positions_at_range},
	{"occupied_space", test_occupied_space},
	{NULL, NULL}
};
