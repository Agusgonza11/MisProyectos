//
// Created by ignat on 19/05/22.
//

#include "./acutest.h"
#include "../src/Model/Map/block_terrain.h"
#include "../src/Model/Mobility/infantry_mobility.h"

void test_infantry_mobility(void)
{
	InfantryMobility mobility;

	TEST_CHECK(mobility.can_traverse(sand));
	TEST_CHECK(mobility.can_traverse(dunes));
	TEST_CHECK(mobility.can_traverse(rock));
	TEST_CHECK(mobility.can_traverse(peaks));
	TEST_CHECK(!mobility.can_traverse(cliffs));
}

TEST_LIST = {
	{"fremen_mobility", test_infantry_mobility},
	{NULL, NULL}
};