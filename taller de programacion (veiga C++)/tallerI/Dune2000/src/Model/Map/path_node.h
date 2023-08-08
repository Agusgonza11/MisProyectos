//
// Created by ignat on 19/05/22.
//

#ifndef DUNE2000_PATH_NODE_H
#define DUNE2000_PATH_NODE_H

#include "./block_position.h"

class PathNode {
	BlockPosition pos;
	BlockPosition previous;
	double g_cost;
	double h_cost;
	bool origin;

	public:
	PathNode(BlockPosition pos_, BlockPosition prev_pos, double g_cost, BlockPosition dst);
	PathNode(BlockPosition pos_, PathNode prev_node, BlockPosition dst);

	void set_as_origin();

	bool is_origin() const;

	BlockPosition get_pos() const;

	BlockPosition get_previous() const;

	/*
	 * El operador < habla sobre
	 * la prioridad de cada nodo
	 * Menor f_cost = mayor prioridad
	 */
	bool operator<(const PathNode& other) const;

	~PathNode();

	PathNode(const PathNode& other);
	PathNode& operator=(const PathNode& other);

	private:
	double f_cost() const;
};

#endif //DUNE2000_PATH_NODE_H
