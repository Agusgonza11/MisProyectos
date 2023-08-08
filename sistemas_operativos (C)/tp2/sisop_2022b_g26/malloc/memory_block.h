#ifndef _MEMORY_BLOCK_H_
#define _MEMORY_BLOCK_H_

#include <sys/mman.h>
#include <string.h>
#include "printfmt.h"
#include "header.h"

#define MAGIC_NUMBER 777
#define MIN_REGION_SIZE 8  // TO BE DETERMINED. PLACEHOLDER
#define INITIAL_BLOCK_SIZE 16384

struct memory_block {
	void *mem_ptr;
	size_t mem_size;
	struct header *head;
	int issued_regions;  // starts with region 0
	int block_id;
	struct memory_block *next;
};

void memory_block_print_first_header(struct memory_block *ptr);
int memory_block_create(struct memory_block *block_ptr,
                        int block_id,
                        size_t size,
                        bool calloc);
struct header *memory_block_find_free_region(struct memory_block *block,
                                             size_t size);
void memory_block_split(struct memory_block *block, int id, size_t requested_size);
struct memory_block *memory_block_get_next(struct memory_block *block);
size_t memory_block_get_size(struct memory_block *block);
void *memory_block_get_memory(struct memory_block *block);
int memory_block_get_id(struct memory_block *block);
void memory_block_set_next(struct memory_block *block, struct memory_block *next);
void print_block(struct memory_block *block_ptr);
bool memory_block_is_valid_address(struct memory_block *block, void *addr);

#endif  // _MEMORY_BLOCK_H_
