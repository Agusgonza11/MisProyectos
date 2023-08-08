//
// Created by ignat on 05/06/22.
//

#include "mock_server.h"
#include "../Model/Entities/unit.h"
#include "../Model/configurations.h"

typedef std::pair<BlockPosition, BlockTerrain> TerrainPos;

MockServer::MockServer(int limitPlayres, std::string playerName, int team) :
cu(360, 360){
	players.insert(std::pair<std::string, int>(playerName, team));
	this->limitPlayers = limitPlayers;
	this->actualPlayers = 1;
}

bool MockServer::addPlayer(std::string playerName, int team){
	if(actualPlayers + 1 > limitPlayers) return false;
	players.insert(std::pair<std::string, int>(playerName, team));
	return true;
}

std::tuple<int, int> MockServer::listGame(){
	return make_tuple(limitPlayers, actualPlayers);
}

void MockServer::load_map(std::vector<std::pair<struct map_coor, unsigned int>> terrains)
{
	vector<pair<BlockPosition, BlockTerrain>> cu_terrains;
	for (auto const &it : terrains) {
		BlockPosition pos(it.first.row, it.first.col);
		BlockTerrain terrain = this->parse_terrain(it.second);
		cu_terrains.push_back(pair<BlockPosition, BlockTerrain>(pos, terrain));
	}
	this->cu.set_terrains(cu_terrains);
}

void MockServer::create_unit(unsigned int player_id, unsigned int type_id, unsigned int row, unsigned int col)
{
	BlockPosition pos(row, col);
	this->cu.cmd_create(player_id, type_id, pos);
}

void MockServer::move_unit(unsigned int id, unsigned int row_dst, unsigned int col_dst)
{
	BlockPosition dst(row_dst, col_dst);
	this->cu.cmd_move(id, dst);
}

void MockServer::unit_attack(unsigned int id, unsigned int target_id)
{
	this->cu.cmd_attack(id, target_id);
}

void MockServer::update(unsigned int time_delta)
{
	this->cu.update(time_delta);
}

std::vector<struct RawUnit> MockServer::get_state() const
{
	std::vector<shared_ptr<Teamable>> units = this->cu.get_state();
	std::vector<RawUnit> raw_units;
	struct RawUnit raw_unit;
	for (auto const &it : units) {
		shared_ptr<Unit> unit = dynamic_pointer_cast<Unit>(it);
		if (unit->get_state() == creating)
			continue;

		raw_unit.id = unit->get_id();
		raw_unit.player_id = unit->get_player_id();
		raw_unit.type_id = unit->get_type_id();
		raw_unit.weapon_id = unit->get_weapon_id();
		raw_unit.hp = unit->get_hp();
		raw_unit.row = unit->get_position().row();
		raw_unit.col = unit->get_position().col();
		raw_unit.facing_row = unit->facing_position().row();
		raw_unit.facing_col = unit->facing_position().col();
		raw_unit.target_id = unit->target_id();
		if (unit->get_state() == neutral)
			raw_unit.state = "neutral";
		else if (unit->get_state() == autoattacking
		or unit->get_state() == attacking)
			raw_unit.state = "attacking";
		else
			raw_unit.state = "moving";

		raw_units.push_back(raw_unit);
	}
	return raw_units;
}

MockServer::~MockServer() = default;

BlockTerrain MockServer::parse_terrain(unsigned int terrain_id) const
{
	if (terrain_id == CONFIGS.DUNES_ID)
		return dunes;
	else if (terrain_id == CONFIGS.ROCK_ID)
		return rock;
	else if (terrain_id == CONFIGS.PEAKS_ID)
		return peaks;
	else if (terrain_id == CONFIGS.CLIFFS_ID)
		return cliffs;
	else if (terrain_id == CONFIGS.CONSTRUCTION_ID)
		return construction;
	else
		return sand;
}
