//
// Created by ignat on 19/05/22.
//

#include "./acutest.h"
#include "../src/Model/Map/block_position.h"
#include <cmath>
#include <limits>

void test_getters(void)
{
	unsigned int max = std::numeric_limits<unsigned int>::max();
	BlockPosition pos1(0, 0);
	BlockPosition pos2(13, 67);
	BlockPosition pos3(0, max);

	TEST_CHECK(pos1.col() == 0);
	TEST_CHECK(pos2.row() == 13);
	TEST_CHECK(pos2.col() == 67);
	TEST_CHECK(pos3.row() == 0);
	TEST_CHECK(pos3.col() == max);
}

void test_distance_to_self_is_zero(void)
{
	BlockPosition pos(3, 7);

	TEST_CHECK(pos.distance_to(pos) == 0);
}

void test_distance_from_origin_to_one_one(void)
{
	BlockPosition org(0, 0);
	BlockPosition dst(1, 1);

	double distance = org.distance_to(dst);
	TEST_CHECK(distance == sqrt(2));
	TEST_MSG("Expected: %f", sqrt(2));
	TEST_MSG("Produced: %f", distance);
}

void test_extreme_distance(void)
{
	unsigned int min = std::numeric_limits<unsigned int>::min();
	unsigned int max = std::numeric_limits<unsigned int>::max();
	BlockPosition org(min, min);
	BlockPosition dst(max, max);

	double distance = org.distance_to(dst);
	TEST_CHECK(distance == sqrt(2 * (double) max * (double) max));
	TEST_MSG("Expected: %f", sqrt(2 * (double) max * (double) max));
	TEST_MSG("Produced: %f", distance);
}

void test_equals(void)
{
	BlockPosition pos1(0, 1);
	BlockPosition pos2(0, 1);
	BlockPosition pos3(1, 1);

	TEST_CHECK(pos1 == pos2);
	TEST_CHECK(!(pos1 == pos3));
}

void test_not_equals(void)
{
	BlockPosition pos1(0, 1);
	BlockPosition pos2(0, 1);
	BlockPosition pos3(1, 1);

	TEST_CHECK(!(pos1 != pos2));
	TEST_CHECK(pos1 != pos3);
}

void test_copy_constructor(void)
{
	BlockPosition pos1(3, 7);
	BlockPosition pos2 = pos1;

	TEST_CHECK(pos2.row() == 3);
	TEST_CHECK(pos2.col() == 7);
}

void test_assign(void)
{
	BlockPosition pos1(3, 7);
	BlockPosition pos2(10, 20);

	pos1 = pos2;

	TEST_CHECK(pos1.row() == 10);
	TEST_CHECK(pos1.col() == 20);
}

void test_less_operator(void)
{
	BlockPosition pos1(2, 3);
	BlockPosition pos2(2, 3);
	BlockPosition pos3(1, 4);
	BlockPosition pos4(3, 0);

	TEST_CHECK(!(pos1 < pos2));
	TEST_CHECK(!(pos2 < pos1));
	TEST_CHECK(pos3 < pos1);
	TEST_CHECK(pos1 < pos4);
}

TEST_LIST = {
	{"getters", test_getters},
	{"distance_to_self", test_distance_to_self_is_zero},
	{"distance_sqrt_of_2", test_distance_from_origin_to_one_one},
	{"extreme_distance", test_extreme_distance},
	{"equals", test_equals},
	{"not_equals", test_not_equals},
	{"copy_constructor", test_copy_constructor},
	{"assign", test_assign},
	{"less_operator", test_less_operator},
	{NULL,NULL}
};
