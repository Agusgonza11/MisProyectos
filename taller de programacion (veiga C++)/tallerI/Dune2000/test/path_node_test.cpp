//
// Created by ignat on 20/05/22.
//

#include "./acutest.h"
#include "../src/Model/Map/path_node.h"
#include <queue>

void test_creation_and_getters(void)
{
	BlockPosition pos(3, 7);
	BlockPosition prev(3, 6);
	BlockPosition dst(3, 11);

	PathNode node1(pos, prev, 0, dst);
	PathNode node2(prev, node1, dst);

	TEST_CHECK(node1.get_pos() == pos);
	TEST_CHECK(node1.get_previous() == prev);
	TEST_CHECK(!node1.is_origin());
	TEST_CHECK(node2.get_pos() == prev);
	TEST_CHECK(node2.get_previous() == pos);

	node1.set_as_origin();
	TEST_CHECK(node1.is_origin());
}

void test_operator_less(void)
{
	BlockPosition pos1(3, 7);
	BlockPosition pos2(3, 5);
	BlockPosition pos3(2, 6);
	BlockPosition prev(3, 6);
	BlockPosition dst(3, 11);

	PathNode node1(pos1, prev, 1, dst);
	PathNode node2(pos2, prev, 1, dst);
	PathNode node3(pos3, prev, 1, dst);
	PathNode node4(pos3, prev, 1, dst);

	TEST_CHECK(node2 < node1);
	TEST_CHECK(node2 < node3);
	TEST_CHECK(!(node3 < node4));
	TEST_CHECK(!(node4 < node3));
}

void test_priority_queue(void)
{
	BlockPosition pos1(3, 7);
	BlockPosition pos2(3, 5);
	BlockPosition pos3(2, 6);
	BlockPosition pos4(4, 7);
	BlockPosition prev(3, 6);
	BlockPosition dst(3, 11);

	PathNode node1(pos1, prev, 1, dst);
	PathNode node2(pos2, prev, 1, dst);
	PathNode node3(pos3, prev, 1, dst);
	PathNode node4(pos4, prev, 1, dst);

	std::priority_queue<PathNode> q;
	q.push(node1);
	q.push(node2);
	q.push(node3);
	q.push(node4);

	TEST_CHECK(q.size() == 4);

	PathNode node = q.top();
	q.pop();
	TEST_CHECK(node.get_pos() == pos1);

	node = q.top();
	q.pop();
	TEST_CHECK(node.get_pos() == pos4);

	node = q.top();
	q.pop();
	TEST_CHECK(node.get_pos() == pos3);

	node = q.top();
	q.pop();
	TEST_CHECK(node.get_pos() == pos2);
}

TEST_LIST = {
	{"creation_and_getters", test_creation_and_getters},
	{"operator_less", test_operator_less},
	{"priority_queue", test_priority_queue},
	{NULL, NULL}
};

