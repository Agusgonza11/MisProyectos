//
// Created by ignat on 30/05/22.
//

#include "./acutest.h"
#include "../src/Server/control_unit.h"

void test_create_unit(void)
{
	ControlUnit cu(4, 5);
	cu.create(BlockPosition(3, 0));
	cu.create(BlockPosition(4, 5)); // out of range

	std::vector<Movable> units = cu.get_state();

	TEST_CHECK(units.size() == 1);
	TEST_CHECK(units.front().is_at_position(BlockPosition(3, 0)));
}

void test_move_unit(void)
{
	ControlUnit cu(4, 5);
	cu.create(BlockPosition(3, 0));
	int id = cu.get_state().front().get_id();
	cu.move(id, BlockPosition(1, 2));
	cu.update();

	std::vector<Movable> units = cu.get_state();
	TEST_CHECK(units.front().is_at_position(BlockPosition(2, 1)));
	cu.update();

	units = cu.get_state();
	TEST_CHECK(units.front().is_at_position(BlockPosition(1, 2)));
	cu.update();

	units = cu.get_state();
	TEST_CHECK(units.front().is_at_position(BlockPosition(1, 2)));
}

TEST_LIST = {
	{"create_unit", test_create_unit},
	{"move_unit", test_move_unit},
	{NULL, NULL}
};
