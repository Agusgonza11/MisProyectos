//
// Created by ignat on 19/05/22.
//

#ifndef DUNE2000_BLOCKTERRAIN_H
#define DUNE2000_BLOCKTERRAIN_H

/*
 * Siempre que se modifique este
 * enum, verificar UnitMovility y
 * todas sus clases hijas
 *
 * Tambien se podria impelementar
 * con un patron visitor
 * pero por ahora es mucho lio
 */
enum BlockTerrain {
	sand,
	dunes,
	rock,
	peaks,
	cliffs,
	construction
};

#endif //DUNE2000_BLOCKTERRAIN_H
