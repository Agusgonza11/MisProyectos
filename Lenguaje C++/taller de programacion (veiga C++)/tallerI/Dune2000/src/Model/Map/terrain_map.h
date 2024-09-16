//
// Created by ignat on 19/05/22.
//

#ifndef DUNE2000_TERRAINMAP_H
#define DUNE2000_TERRAINMAP_H

#include "./block_terrain.h"
#include "./block_position.h"
#include "../Mobility/unit_mobility.h"
#include "./path_node.h"
#include <list>
#include <vector>
#include <map>

class TerrainMap {
	BlockTerrain **map;
	unsigned int rows;
	unsigned int cols;

	public:
	TerrainMap(unsigned int rows_, unsigned int cols_);

	/*
	 * Devuelve una lista ordenada del camino obtenido
	 * mediante el algoritmo A*
	 * Si la lista esta vacia es que no encontro ningun camino
	 */
	std::vector<BlockPosition>
	get_path(BlockPosition origin, BlockPosition destination, const UnitMobility &mob) const;

	bool invalid_position(BlockPosition pos) const;

	/*
	 * Devuelve la posiciones validas por las que puede
	 * pasar la movilidad
	 */
	std::vector<BlockPosition>
	filter(const std::vector<BlockPosition> &positions, const UnitMobility &mob) const;

	BlockTerrain at(BlockPosition pos) const;
	BlockTerrain at(unsigned int row, unsigned int col) const;

	void change_terrain(BlockPosition pos, BlockTerrain terrain);

	~TerrainMap();

	private:
	void validate_positions(BlockPosition org, BlockPosition dst) const;

	bool already_visited(BlockPosition pos, const std::map<BlockPosition, PathNode> &visited) const;

	std::list<BlockPosition>
	get_neighbours(BlockPosition pos, const UnitMobility &mob) const;

	std::vector<BlockPosition>
	build_path(const std::map<BlockPosition, PathNode> &visited, BlockPosition dst) const;
};

#endif //DUNE2000_TERRAINMAP_H
