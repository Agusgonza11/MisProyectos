//
// Created by ignat on 19/05/22.
//

#ifndef DUNE2000_BLOCK_POSITION_H
#define DUNE2000_BLOCK_POSITION_H

#include <complex>

class BlockPosition {
	/*
	 * Uso un complejo para tener que codear menos
	 * Almacenar enteros como numeros floating point
	 * puede traer errores
	 * Double deberia ser lo suficientemente preciso
	 * pero no estoy completamente seguro
	 */
	std::complex<double> pos;

	public:
	BlockPosition(unsigned int row, unsigned int col);

	unsigned int row() const;
	unsigned int col() const;

	double distance_to(const BlockPosition& other) const;

	bool operator==(const BlockPosition& other) const;
	bool operator!=(const BlockPosition& other) const;
	bool operator<(const BlockPosition& other) const;

	BlockPosition(const BlockPosition& other);
	BlockPosition& operator=(const BlockPosition& other);

	~BlockPosition();
};

#endif //DUNE2000_BLOCK_POSITION_H
