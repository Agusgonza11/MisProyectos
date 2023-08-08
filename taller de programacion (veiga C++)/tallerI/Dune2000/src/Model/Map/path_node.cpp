//
// Created by ignat on 19/05/22.
//

#include "./path_node.h"

PathNode::PathNode(BlockPosition pos_, BlockPosition prev_pos, double g_cost_, BlockPosition dst) :
pos(pos_),
previous(prev_pos),
g_cost(g_cost_),
h_cost(pos.distance_to(dst)),
origin(false){}

PathNode::PathNode(BlockPosition pos_, PathNode prev_node, BlockPosition dst) :
pos(pos_),
previous(prev_node.get_pos()),
g_cost(prev_node.g_cost + pos.distance_to(previous)),
h_cost(pos.distance_to(dst)),
origin(false){}

void PathNode::set_as_origin()
{
	this->origin = true;
}

bool PathNode::is_origin() const
{
	return this->origin;
}

BlockPosition PathNode::get_pos() const
{
	return this->pos;
}

BlockPosition PathNode::get_previous() const
{
	return this->previous;
}

bool PathNode::operator<(const PathNode &other) const
{
	/*
	 * Quiero que en la priority_queue
	 * se popeen primero los que tienen
	 * menor f_cost
	 * Ver algoritmo A*
	 */
	return this->f_cost() > other.f_cost();
}

PathNode::~PathNode() = default;

PathNode::PathNode(const PathNode &other) = default;

PathNode &PathNode::operator=(const PathNode &other) = default;

double PathNode::f_cost() const
{
	return this->g_cost + this->h_cost;
}