#ifndef COMMON_MODEL_H
#define COMMON_MODEL_H
#include <vector>
#include <string>
#include <tuple>
#include <map>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "common_unit.h"
#include "common_ground.h"
#include "common_explosion.h"
#include "../Server/mock_server.h"

class Model {
	std::map <int, Unit*> units;
	std::vector<Explosion*> explosions;
	std::vector<Unit*> units_to_eliminate;
	Ground ground;	
	bool one_unit_can_moves;
	int team;
	
	void deleteUnits();
	
	void foundEliminate(std::vector<struct RawUnit> &received_units);

	public:
	Model(std::map <int, Unit*> &units, Ground &grounds, int team);
	
	void update(std::vector<struct RawUnit> received_units);
	
	int get_y_size();
	
	int get_x_size();

	void move_by_position(int id);
	
	int get_unit(float cordX, float cordY);

	int get_build(float cordX, float cordY);
	
	std::vector<int> get_units_can_moves();

	std::vector<Unit*> get_units_to_eliminate();

	std::vector<Explosion*> get_explosions();

	void reproduceSoundMove(int id);
	
	bool a_unit_can_moves();

	void no_enable_moves();
	
	void unit_enable_move(int unit_id);

	void build_selected(int build_id);

	void deselected_builds();

	bool is_build_there(float cordX, float cordY);
	
	bool is_unit_there(float cordX, float cordY);

	bool is_enemy_there(float cordX, float cordY);
	
	int get_units_size();

	int get_team();

	void delete_explosion(int i);

	void eliminate_unit(size_t position);

	Ground &get_grounds();
	
	std::map <int, Unit*> &get_units();
	
	~Model();
	
};
#endif
