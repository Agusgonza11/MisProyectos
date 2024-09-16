//
// Created by ignat on 05/06/22.
//

#ifndef DUNE2000_MOCKSERVER_H
#define DUNE2000_MOCKSERVER_H

#include "control_unit.h"
#include <vector>
#include <string>

typedef std::vector<std::pair<unsigned int, unsigned int>> Cliffs;

struct RawUnit {
	unsigned int id;
	unsigned int player_id;
	unsigned int type_id;
	unsigned int weapon_id;
	unsigned int hp;
	unsigned int row;
	unsigned int col;
	unsigned int facing_row;
	unsigned int facing_col;
	unsigned int target_id;
	std::string state;
	unsigned int team;
};

struct map_coor {
	unsigned int row;
	unsigned int col;
};

class MockServer {
	ControlUnit cu;
	std::map<std::string, int> players;
	int limitPlayers;
	int actualPlayers;

public:
	MockServer(int limitPlayres, std::string playerName, int team);

	bool addPlayer(std::string playerName, int team);

	std::tuple<int, int> listGame();

	void load_map(std::vector<std::pair<struct map_coor, unsigned int>> terrains);

	void create_unit(unsigned int player_id, unsigned int type_id, unsigned int row, unsigned int col);

	void move_unit(unsigned int id, unsigned int row_dst, unsigned int col_dst);

	void unit_attack(unsigned int id, unsigned int target_id);

	void update(unsigned int time_delta);

	std::vector<struct RawUnit> get_state() const;

	~MockServer();

private:
	BlockTerrain parse_terrain(unsigned int terrain_id) const;
};

#endif //DUNE2000_MOCKSERVER_H
