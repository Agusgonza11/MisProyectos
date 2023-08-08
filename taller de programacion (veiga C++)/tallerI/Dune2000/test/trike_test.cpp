//
// Created by ignat on 20/06/22.
//

#include "acutest.h"
#include "../src/Model/Entities/trike.h"
#include "../src/Model/configurations.h"

void test_move(void)
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
	Trike trike(1, 2, org, map, game_objects, 1);
	trike.update(CONFIGS.TRIKE_CREATION_TIME);
	trike.move_to(dst);

	trike.update(CONFIGS.TRIKE_TRAVERSE_TIME);
	TEST_CHECK(trike.get_position() == BlockPosition(3, 1));
	trike.update(CONFIGS.TRIKE_TRAVERSE_TIME);
	TEST_CHECK(trike.get_position() == BlockPosition(3, 2));
	trike.update(CONFIGS.TRIKE_TRAVERSE_TIME);
	TEST_CHECK(trike.get_position() == BlockPosition(2, 3));
	trike.update(CONFIGS.TRIKE_TRAVERSE_TIME);
	TEST_CHECK(trike.get_position() == dst);
}

TEST_LIST = {
	{"move", test_move},
	{NULL, NULL}
};