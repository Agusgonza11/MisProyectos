#include "block_manager.h"

bool
block_manager_initialize(struct block_manager *man_ptr)
{
	size_t amount_of_memory = SMALL_BLOCK_SIZE / 2;
	void *ptr = mmap(NULL,
	                 INITIAL_BLOCK_SIZE,
	                 PROT_READ | PROT_WRITE,
	                 MAP_SHARED | MAP_ANONYMOUS,
	                 -1,
	                 0);
	if (ptr == MAP_FAILED) {
		printfmt("- BLOCK MANAGER: MAP_FAILED\n");
		return false;
	}
	man_ptr->mem_ptr = ptr;
	man_ptr->memory_for_block_structs = amount_of_memory;
	man_ptr->total_memory_in_blocks = 0;
	man_ptr->head_block = NULL;

	man_ptr->small_block_quantity = 0;
	man_ptr->medium_block_quantity = 0;
	man_ptr->large_block_quantity = 0;

	return true;
}


bool
block_manager_create_block(struct block_manager *man_ptr, size_t size, bool calloc)
{
	struct memory_block block;

	size = block_manager_validate_block_quantity(man_ptr, size);
	if (size == 0) {
		return false;
	}

	if (man_ptr->total_memory_in_blocks + size > UPPER_LIMIT_SIZE) {
		return false;
	}

	if (memory_block_create(&block, man_ptr->issued_blocks, size, calloc) ==
	    -1) {
		return false;
	}

	man_ptr->issued_blocks++;
	struct memory_block *last_block = man_ptr->head_block;

	if (last_block == NULL) {
		// FIRST BLOCK ALLOCATION
		memcpy(man_ptr->mem_ptr, &block, sizeof(block));
		man_ptr->head_block = man_ptr->mem_ptr;
		man_ptr->last_block = man_ptr->mem_ptr;
	} else {
		// THERE WAS ALREADY AN EXISTING BLOCK

		struct memory_block *last_smaller_block = NULL;

		while (last_block->next) {
			if (memory_block_get_size(
			            memory_block_get_next(last_block)) > size &&
			    !last_smaller_block) {
				last_smaller_block = last_block;
			}
			last_block = last_block->next;
		}

		void *address_of_next_block_struct = man_ptr->last_block + 1;

		if (!last_smaller_block) {
			last_block->next = address_of_next_block_struct;

		} else {
			block.next = last_smaller_block->next;
			last_smaller_block->next = address_of_next_block_struct;
		}

		memcpy(address_of_next_block_struct,
		       &block,
		       sizeof(struct memory_block));

		man_ptr->last_block = address_of_next_block_struct;
	}

	man_ptr->total_memory_in_blocks += size;
	block_manager_add_block_quantity(man_ptr, size);
	return true;
}

void
block_manager_add_block_quantity(struct block_manager *man_ptr, size_t size)
{
	if (size == SMALL_BLOCK_SIZE) {
		man_ptr->small_block_quantity += 1;
	} else if (size == MEDIUM_BLOCK_SIZE) {
		man_ptr->medium_block_quantity += 1;
	} else {
		man_ptr->large_block_quantity += 1;
	}
}

size_t
block_manager_validate_block_quantity(struct block_manager *man_ptr, size_t size)
{
	if (size <= SMALL_BLOCK_SIZE &&
	    man_ptr->small_block_quantity < MAX_SMALL_BLOCKS) {
		return SMALL_BLOCK_SIZE;
	}
	if (size <= MEDIUM_BLOCK_SIZE &&
	    man_ptr->medium_block_quantity < MAX_MEDIUM_BLOCKS) {
		return MEDIUM_BLOCK_SIZE;
	}
	if (size <= LARGE_BLOCK_SIZE &&
	    man_ptr->large_block_quantity < MAX_LARGE_BLOCKS) {
		return LARGE_BLOCK_SIZE;
	}

	return 0;
}


struct header *
block_manager_find_free_region(struct block_manager *man, size_t size)
{
	printfmt("- BLOCK MANAGER: Issued %d blocks. Searching for a "
	         "free region of size: %d\n",
	         man->issued_blocks,
	         size);

	struct memory_block *blk = man->head_block;
	struct header *aux_ptr = NULL;

	while (blk != NULL) {
		printfmt("- BLOCK MANAGER: Searching block %d for free "
		         "regions\n",
		         blk->block_id);
		aux_ptr = (void *) memory_block_find_free_region(blk, size);
		if (aux_ptr != NULL) {
			break;
		}
		blk = blk->next;
	}
	return aux_ptr;
}

struct memory_block *
block_manager_get_block(struct block_manager *man, int id)
{
	struct memory_block *curr_block = man->head_block;

	while (curr_block != NULL) {
		if (curr_block->block_id == id) {
			return curr_block;
		}
		curr_block = curr_block->next;
	}
	return curr_block;
}

void
block_manager_split_region(struct block_manager *man,
                           struct header *head,
                           size_t size)
{
	size_t block_id = header_get_block_id(head);
	int header_id = header_get_id(head);
	struct memory_block *target_block =
	        block_manager_get_block(man, block_id);
	memory_block_split(target_block, header_id, size);
}


void
block_manager_print_status(struct block_manager *man)
{
	printfmt("********************** Block Manager "
	         "Status***********************\n");
	printfmt("Block 0\n");
	struct memory_block *block = man->head_block;
	struct header *head = block->head;
	header_print_current_and_following_headers(head);
	printfmt("********************** Block manager "
	         "END**************************\n");
}

size_t
block_manager_get_min_memory_required(size_t size)
{
	if (size < SMALL_BLOCK_SIZE) {
		return SMALL_BLOCK_SIZE;
	}
	if (size < MEDIUM_BLOCK_SIZE) {
		return MEDIUM_BLOCK_SIZE;
	}
	return LARGE_BLOCK_SIZE;
}

// NO CONTEMPLA QUE SE LIBERA EL ULTIMO BLOQUE
// NEED TO VALIDATE MUNMAP ERROR
void
block_manager_free_block(struct block_manager *man, struct header *head)
{
	int block_id = header_get_block_id(head);

	struct memory_block *mem_block = block_manager_get_block(man, block_id);
	struct memory_block *next_mem_block = memory_block_get_next(mem_block);
	struct memory_block *head_mem_block = man->head_block;

	// check if the block has more than one region
	if (mem_block->head->next == NULL) {
		// there is only one block.
		size_t size_to_liberate = memory_block_get_size(mem_block);

		// it is necessary to change the "next" mappings in the previous block
		// if there is one.
		// CASE 1: the first block is the one getting erased
		if (memory_block_get_id(head_mem_block) == block_id) {
			// change the head block
			man->head_block = next_mem_block;
		} else {
			// CASE 2: the block getting erased is not the first one
			while (memory_block_get_id(head_mem_block->next) !=
			       block_id) {
				head_mem_block =
				        memory_block_get_next(head_mem_block);
			}
			memory_block_set_next(head_mem_block, next_mem_block);
		}

		// update the memory currently allocated
		man->total_memory_in_blocks -= size_to_liberate;
		munmap(memory_block_get_memory(mem_block), size_to_liberate);
	}
}

bool
block_manager_is_valid_address(struct block_manager *manager, void *addr)
{
	struct memory_block *block = manager->head_block;
	while (block != NULL) {
		if (memory_block_is_valid_address(block, addr)) {
			return true;
		}
		block = block->next;
	}
	return false;
}