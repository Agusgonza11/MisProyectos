//
// Created by ignat on 05/06/22.
//

#include "acutest.h"
#include "../src/Server/mock_server.h"

void test_empty(void)
{
	MockServer srv;
	srv.update(100);
	TEST_CHECK(srv.get_state().empty());
}

void test_move(void)
{
	MockServer srv;
	vector<pair<struct map_coor, unsigned int>> terrains;
	for (unsigned int i = 60; i <= 100; i++)
		terrains.push_back(pair<struct map_coor, unsigned >({i, 60}, 4));
	srv.load_map(terrains);
	srv.create_unit(1, 1, 70, 59);
	srv.update(60000);
	unsigned int id = srv.get_state().front().id;
	srv.move_unit(id, 70, 61);
	srv.update(450);
	struct RawUnit unit = srv.get_state().front();

	TEST_CHECK(unit.row == 69);
	TEST_CHECK(unit.col == 59);
	TEST_CHECK(unit.facing_row == 68);
	TEST_CHECK(unit.state == "moving");
}

void test_autoattack(void)
{
	MockServer srv;
	srv.create_unit(1, 1, 70, 59);
	srv.create_unit(2, 1, 69, 59);
	srv.update(60000); // se terminan de crear
	srv.update(0); // se descubren entre si y se preparan para atacar
	srv.update(167); // atacan
	std::vector<RawUnit> units = srv.get_state();
	TEST_CHECK(units.size() == 2);
	TEST_CHECK(units.front().hp == 47);
	TEST_CHECK(units.back().hp == 47);
	TEST_CHECK(units.front().state == "attacking");
	TEST_CHECK(units.back().state == "attacking");
}

void test_units_die(void)
{
	MockServer srv;
	srv.create_unit(1, 1, 70, 59);
	srv.create_unit(2, 1, 69, 59);
	srv.update(60000); // se terminan de crear
	srv.update(0); // se descubren entre si y se preparan para atacar
	for (int i = 0; i < 50; i++)
		srv.update(167); // atacan
	std::vector<RawUnit> units = srv.get_state();
	TEST_CHECK(units.size() == 1);
	TEST_CHECK(units.front().hp == 2);
}

TEST_LIST = {
	{"empty", test_empty},
	{"move", test_move},
	{"autoattack", test_autoattack},
	{"units_death", test_units_die},
	{NULL, NULL}
};