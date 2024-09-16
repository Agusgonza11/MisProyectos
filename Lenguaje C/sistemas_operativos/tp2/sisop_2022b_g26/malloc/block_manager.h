#ifndef _BLOCK_MANAGER_H_
#define _BLOCK_MANAGER_H_

#define SMALL_BLOCK_SIZE 16384
#define MEDIUM_BLOCK_SIZE 1048576
#define LARGE_BLOCK_SIZE 33554432

#define MAX_SMALL_BLOCKS 10
#define MAX_MEDIUM_BLOCKS 10
#define MAX_LARGE_BLOCKS 10

#define UPPER_LIMIT_SIZE 100663296  // it is three times the LARGE_BLOCK_SIZE

#ifndef MEMORY_BLOCK
#include "memory_block.h"
#endif
#include <sys/mman.h>


struct block_manager {
	int issued_blocks;  // Cantidad de bloques creados. Sirven para generar sus ID
	struct memory_block *head_block;  // Primer bloque de la lista de bloques
	struct memory_block *last_block;  // Primer bloque de la lista de bloque
	size_t memory_for_block_structs;  // Cantidad de memoria para guardar los bloques
	size_t total_memory_in_blocks;
	void *mem_ptr;  // La memoria donde se guardan los structs bloques

	size_t small_block_quantity;
	size_t medium_block_quantity;
	size_t large_block_quantity;
};

bool block_manager_initialize(struct block_manager *man_ptr);

bool block_manager_create_block(struct block_manager *man_ptr,
                                size_t size,
                                bool calloc);

struct header *block_manager_find_free_region(struct block_manager *man,
                                              size_t size);

struct memory_block *block_manager_get_block(struct block_manager *man, int id);

void block_manager_split_region(struct block_manager *man,
                                struct header *head,
                                size_t size);

void block_manager_print_status(struct block_manager *man);

size_t block_manager_get_min_memory_required(size_t size);

void block_manager_free_block(struct block_manager *man, struct header *head);

void block_manager_add_block_quantity(struct block_manager *man_ptr, size_t size);

size_t block_manager_validate_block_quantity(struct block_manager *man_ptr,
                                             size_t size);
bool block_manager_is_valid_address(struct block_manager *man, void *addr);


#endif  // _BLOCK_MANAGER_
