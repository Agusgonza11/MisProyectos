//
// Created by ignat on 16/06/22.
//

#include "acutest.h"
#include "../src/Server/entity_factory.h"

void test_create_light_infantry(void)
{
	TerrainMap map(4, 5);
	std::map<unsigned int, TeamablePtr> game_objects;
	EntityFactory factory(map, game_objects);

	factory.create(1, 1, BlockPosition(3, 0));

	TEST_CHECK(game_objects.size() == 1);
	TEST_CHECK(game_objects.count(1) == 1);
	TEST_CHECK(game_objects.at(1)->get_type_id() == 1);
}

TEST_LIST = {
	{"create_light_infantry", test_create_light_infantry},
	{NULL, NULL}
};