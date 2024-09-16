//
// Created by ignat on 21/05/22.
//

#include "./acutest.h"
#include "../src/Model/Map/terrain_map.h"
#include "../src/Model/Mobility/infantry_mobility.h"

void test_at(void)
{
	TerrainMap map(20, 22);

	TEST_CHECK(map.at(BlockPosition(0, 0)) == sand);
	TEST_CHECK(map.at(BlockPosition(19, 21)) == sand);
	TEST_EXCEPTION(map.at(BlockPosition(20, 0)), std::out_of_range);
	TEST_EXCEPTION(map.at(BlockPosition(0, 22)), std::out_of_range);
	TEST_EXCEPTION(map.at(BlockPosition(30, 30)), std::out_of_range);
}

void test_invalid_position(void)
{
	TerrainMap map(20, 22);

	TEST_CHECK(map.invalid_position(BlockPosition(20, 0)));
	TEST_CHECK(map.invalid_position(BlockPosition(0, 22)));
	TEST_CHECK(map.invalid_position(BlockPosition(30, 30)));
	TEST_CHECK(!map.invalid_position(BlockPosition(0, 0)));
	TEST_CHECK(!map.invalid_position(BlockPosition(19, 21)));
}

void test_invalid_org_dst(void)
{
	TerrainMap map(4, 5);

	BlockPosition invalid_pos(5, 6);
	BlockPosition pos(0, 0);
	InfantryMobility mob;

	TEST_EXCEPTION(map.get_path(invalid_pos, pos, mob), std::out_of_range);
	TEST_EXCEPTION(map.get_path(pos, invalid_pos, mob), std::out_of_range);
}

void test_path_to_self(void)
{
	TerrainMap map(4, 5);
	BlockPosition pos(3, 4);
	InfantryMobility mob;

	std::vector<BlockPosition> path = map.get_path(pos, pos, mob);

	TEST_CHECK(path.size() == 1);
	TEST_CHECK(pos == path.front());
	TEST_CHECK(pos == path.back());
}

void test_straight_path_on_x(void)
{
	TerrainMap map(4, 5);
	BlockPosition org(3, 0);
	BlockPosition dst(3, 2);
	InfantryMobility mob;

	std::vector<BlockPosition> path = map.get_path(org, dst, mob);

	TEST_CHECK(path.size() == 3);
	TEST_CHECK(path.at(0) == dst);
	TEST_CHECK(path.at(1) == BlockPosition(3, 1));
	TEST_CHECK(path.at(2) == org);
}

void test_diagonal_path(void)
{
	TerrainMap map(4, 5);
	BlockPosition org(3, 0);
	BlockPosition dst(1, 2);
	InfantryMobility mob;

	std::vector<BlockPosition> path = map.get_path(org, dst, mob);

	TEST_CHECK(path.size() == 3);
	TEST_CHECK(path.at(0) == dst);
	TEST_CHECK(path.at(1) == BlockPosition(2, 1));
	TEST_CHECK(path.at(2) == org);
}

void test_change_terrain(void)
{
	TerrainMap map(4, 6);

	map.change_terrain(BlockPosition(0, 0), cliffs);
	map.change_terrain(BlockPosition(1, 1), dunes);
	map.change_terrain(BlockPosition(2, 2), sand);

	TEST_CHECK(map.at(0, 0) == cliffs);
	TEST_CHECK(map.at(1, 1) == dunes);
	TEST_CHECK(map.at(2, 2) == sand);
	TEST_EXCEPTION(map.change_terrain(BlockPosition(10, 10), cliffs), std::out_of_range);
}

void test_cannot_traverse_destination_block(void)
{
	TerrainMap map(4, 5);
	BlockPosition org(3, 0);
	BlockPosition dst(1, 2);
	InfantryMobility mob;
	map.change_terrain(dst, cliffs);

	std::vector<BlockPosition> path = map.get_path(org, dst, mob);

	TEST_CHECK(path.empty());
}


void test_unreachable_destination(void)
{
	TerrainMap map(4, 5);
	BlockPosition org(3, 0);
	BlockPosition dst(1, 2);
	InfantryMobility mob;
	map.change_terrain(BlockPosition(0, 1), cliffs);
	//map.change_terrain(BlockPosition(0, 2), cliffs);
	map.change_terrain(BlockPosition(0, 3), cliffs);
	map.change_terrain(BlockPosition(1, 3), cliffs);
	map.change_terrain(BlockPosition(2, 3), cliffs);
	map.change_terrain(BlockPosition(2, 2), cliffs);
	map.change_terrain(BlockPosition(2, 1), cliffs);
	map.change_terrain(BlockPosition(1, 1), cliffs);

	std::vector<BlockPosition> path = map.get_path(org, dst, mob);

	TEST_CHECK(path.empty());
}

void test_path_avoiding_obstacles(void)
{
	TerrainMap map(4, 5);
	BlockPosition org(3, 0);
	BlockPosition dst(1, 2);
	InfantryMobility mob;
	map.change_terrain(BlockPosition(0, 1), cliffs);
	//map.change_terrain(BlockPosition(0, 2), cliffs);
	map.change_terrain(BlockPosition(0, 3), cliffs);
	map.change_terrain(BlockPosition(1, 3), cliffs);
	map.change_terrain(BlockPosition(2, 2), cliffs);
	map.change_terrain(BlockPosition(2, 1), cliffs);
	map.change_terrain(BlockPosition(1, 1), cliffs);

	std::vector<BlockPosition> path = map.get_path(org, dst, mob);

	TEST_CHECK(path.size() == 5);
	TEST_CHECK(path.at(4) == org);
	TEST_CHECK(path.at(3) == BlockPosition(3, 1));
	TEST_CHECK(path.at(2) == BlockPosition(3, 2));
	TEST_CHECK(path.at(1) == BlockPosition(2, 3));
	TEST_CHECK(path.at(0) == dst);
}

void test_filter(void)
{
	TerrainMap map(4, 5);
	map.change_terrain(BlockPosition(1, 1), cliffs);
	std::vector<BlockPosition> positions;
	InfantryMobility mob;
	positions.push_back(BlockPosition(0, 0));
	positions.push_back(BlockPosition(1, 1));
	positions.push_back(BlockPosition(4, 5));
	std::vector<BlockPosition> filtered = map.filter(positions, mob);

	TEST_CHECK(filtered.size() == 1);
	TEST_CHECK(filtered.front() == BlockPosition(0, 0));
}

TEST_LIST = {
	{"at_method", test_at},
	{"invalid_position", test_invalid_position},
	{"invalid_path", test_invalid_org_dst},
	{"path_to_self", test_path_to_self},
	{"straight_path_on_x", test_straight_path_on_x},
	{"diagonal_path", test_diagonal_path},
	{"change_terrain", test_change_terrain},
	{"untraversable_dst", test_cannot_traverse_destination_block},
	{"unreachable_destination", test_unreachable_destination},
	{"path_avoiding_obstacles", test_path_avoiding_obstacles},
	{"filer", test_filter},
	{NULL, NULL}
};