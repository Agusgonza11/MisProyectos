#include "memory_block.h"


void
memory_block_set_next(struct memory_block *block, struct memory_block *next)
{
	block->next = next;
}


int
memory_block_get_id(struct memory_block *block)
{
	return block->block_id;
}


void *
memory_block_get_memory(struct memory_block *block)
{
	return block->mem_ptr;
}


size_t
memory_block_get_size(struct memory_block *block)
{
	return block->mem_size;
}


struct memory_block *
memory_block_get_next(struct memory_block *blk)
{
	return blk->next;
}


int
memory_block_create(struct memory_block *block_ptr,
                    int block_id,
                    size_t size,
                    bool calloc)
{
	// assign a 16Kib (16384 bytes) sized block of memory
	int flags = MAP_PRIVATE | MAP_ANONYMOUS;
	void *ptr = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, -1, 0);

	if (ptr == MAP_FAILED) {
		printfmt("- MEMORY BLOCK: MAP FAILED\n");
		return -1;
	}

	if (calloc) {
		char *aux_ptr = (char *) ptr;
		for (size_t i = 0; i < size; i++) {
			*(aux_ptr + i) = 0;
		}
	}

	block_ptr->mem_ptr = ptr;
	block_ptr->mem_size = size;

	struct header first_header = {
		size - sizeof(struct header),
		MAGIC_NUMBER,
		true,
		NULL,
		0,
		block_id,
	};

	if (memcpy(block_ptr->mem_ptr, &first_header, sizeof(first_header)) ==
	    NULL) {
		printfmt("- MEMORY BLOCK: memcpy failed\n");
	} else {
		printfmt("- MEMORY BLOCK: memcpy worked \n");
	}

	block_ptr->head = (struct header *) block_ptr->mem_ptr;
	block_ptr->issued_regions = 1;
	block_ptr->block_id = block_id;
	block_ptr->next = NULL;

	print_block(block_ptr);

	return 0;
}


void
memory_block_split(struct memory_block *block, int id, size_t requested_size)
{
	struct header *head_ptr = block->head;

	while (header_get_id(head_ptr) != id) {
		head_ptr = head_ptr->next;
	}

	size_t remaining_size = header_get_size(head_ptr) - requested_size;

	struct header *next_header = head_ptr->next;

	if (remaining_size >= MIN_REGION_SIZE + sizeof(struct header)) {
		header_put_size(head_ptr, requested_size);

		struct header split_header = { remaining_size -
			                               sizeof(struct header),
			                       MAGIC_NUMBER,
			                       true,
			                       next_header,
			                       block->issued_regions,
			                       block->block_id };
		block->issued_regions++;

		// copy the new header in the free space given by mmap
		void *start_of_next_header = (char *) head_ptr +
		                             header_get_size(head_ptr) +
		                             sizeof(struct header);
		head_ptr->next = start_of_next_header;

		if (!memcpy(start_of_next_header,
		            &split_header,
		            sizeof(struct header))) {
			printfmt("- MEMORY BLOCK: Memcpy for the remaining "
			         "region failed\n");
		}
	}
}


void
memory_block_print_first_header(struct memory_block *ptr)
{
	print_header(ptr->head);
}


struct header *
memory_block_find_free_region(struct memory_block *block, size_t size)
{
	struct header *head = block->head;

#ifdef FIRST_FIT

	while (head) {
		if (head->size >= size && head->free) {
			return head;
		}
		head = head->next;
	}

	printfmt("- MEMORY BLOCK: No region found \n");

#endif

#ifdef BEST_FIT

	struct header *head_to_return = NULL;

	while (head) {
		if (head->size >= size && head->free) {
			if (head_to_return) {
				if (header_get_size(head_to_return) >
				    header_get_size(head)) {
					head_to_return = head;
				}
			} else {
				head_to_return = head;
			}
		}
		head = head->next;
	}

	return head_to_return;


#endif

	return head;
}


void
print_block(struct memory_block *block_ptr)
{
	if (block_ptr == NULL) {
		return;
	}
	printfmtb("\n =================================\n");
	printfmtb("| ID: %d | Block | %p  |\n", block_ptr->block_id, block_ptr);
	printfmtb("|=================================\n");
	printfmtb("| Size:  %d                  \n", block_ptr->mem_size);
	printfmtb(" =================================\n\n");
}

bool
memory_block_is_valid_address(struct memory_block *block, void *addr)
{
	char *memory_beginning = block->mem_ptr;
	size_t memory_size = memory_block_get_size(block);
	void *memory_end = memory_beginning + memory_size;
	if (memory_end > addr && (char *) addr >= memory_beginning) {
		printfmt("- MEMORY BLOCK: Address passed to free valid\n");
		return true;
	}
	return false;
}