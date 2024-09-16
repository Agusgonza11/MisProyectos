#define _DEFAULT_SOURCE

#include "malloc.h"

#include <errno.h>

static void *
error()
{
	errno = ENOMEM;
	return NULL;
}

struct region *region_free_list = NULL;

struct block_manager block_man;

static void
print_all_statistics(void)
{
	struct memory_block *actual = block_man.head_block;

	while (actual) {
		print_block(actual);

		struct header *h = actual->head;

		while (h) {
			print_header(h);
			h = h->next;
		}

		actual = actual->next;
	}
}

void *
malloc(size_t size)
{
	if (size == 0) {
		return NULL;
	}

	// aligns to multiple of 4 bytes
	size = ALIGN4(size);

	// check if the requested memory is bigger than the biggest possible block
	if (size > LARGE_BLOCK_SIZE) {
		printfmt("- MALLOC: Requested memory larger than "
		         "the "
		         "maximum possible\n");
		return error();
	}

	// updates statistics
	amount_of_mallocs++;
	requested_memory += size;

	// initialize block manager
	if (amount_of_mallocs == 1) {
		if (block_manager_initialize(&block_man)) {
			printfmt("- MALLOC: Trying to assign 16 Kib memory\n");

			if (!block_manager_create_block(
			            &block_man, SMALL_BLOCK_SIZE, false)) {
				printfmt("- MALLOC: Failed first block "
				         "allocation\n");

				return error();
			}
		}
	}

	struct header *head = block_manager_find_free_region(&block_man, size);

	if (head == NULL) {
		printfmt("- MALLOC: Find free region failed. Attempting to "
		         "create a new "
		         "block of memory\n");

		// attempt to create a new block and try again
		size_t min_memory_required =
		        block_manager_get_min_memory_required(size);

		if (!block_manager_create_block(
		            &block_man, min_memory_required, false)) {
			printfmt("- MALLOC: Failed to create new block\n");
			return error();
		}

		printfmt("- MALLOC: Created a new block of memory, searching "
		         "for "
		         "a "
		         "region in the new block of memory\n");

		head = block_manager_find_free_region(&block_man, size);
	}

	// change header to not free
	header_occupy(head);

	// split the memory, creating a new region
	block_manager_split_region(&block_man, head, size);

	print_all_statistics();

	return HEADER2PTR(head);
}

void
free(void *ptr)
{
	if (ptr == NULL) {
		printfmt("Attempting to free a NULL pointer\n");
		return;
	}

	// updates statistics
	amount_of_frees++;

	struct header *head = PTR2HEADER(ptr);

	printfmt("- FREE: value of *ptr: %p\n", head);

	// check if the memory address was allocated by malloc
	if (!block_manager_is_valid_address(&block_man, ptr)) {
		printfmt("Attempting to free a not alloc'd memory\n");
		return;
	}

	if (head->free == true) {
		printfmt("Attempting to free an already free region\n");
		return;
	}

	assert(head->free == false);

	head->free = true;

	// region coalescing
	header_coalesce(&block_man, head);

	// attempt to free the block
	block_manager_free_block(&block_man, head);

	print_all_statistics();

	// print_statistics();
}

void *
calloc(size_t nmemb, size_t size)
{
	if (nmemb == 0 || size == 0) {
		return NULL;
	}

	size_t required_memory = ALIGN4(nmemb * size);

	// check if the requested memory is bigger than the biggest possible block
	if (required_memory > LARGE_BLOCK_SIZE) {
		printfmt("- CALLOC: Requested memory larger than "
		         "the "
		         "maximum possible\n");
		return error();
	}

	// updates statistics
	amount_of_mallocs++;
	requested_memory += required_memory;

	// initialize block manager
	if (amount_of_mallocs == 1) {
		if (block_manager_initialize(&block_man)) {
			printfmt("- CALLOC: Trying to assign 16 Kib memory\n");

			if (!block_manager_create_block(
			            &block_man, SMALL_BLOCK_SIZE, true)) {
				printfmt("- CALLOC: Failed first block "
				         "allocation\n");
				return error();
			}
		}
	}

	struct header *head =
	        block_manager_find_free_region(&block_man, required_memory);

	if (head == NULL) {
		printfmt("- CALLOC: Find free region failed. Attempting to "
		         "create a new "
		         "block of memory\n");

		// attempt to create a new block and try again
		size_t min_memory_required =
		        block_manager_get_min_memory_required(required_memory);

		if (!block_manager_create_block(
		            &block_man, min_memory_required, true)) {
			printfmt("- CALLOC: Failed to create new block\n");
			return error();
		}

		printfmt("- CALLOC: Created a new block of memory, searching "
		         "for "
		         "a "
		         "region in the new block of memory\n");

		head = block_manager_find_free_region(&block_man, required_memory);
	}

	// change header to not free
	header_occupy(head);

	// split the memory, creating a new region
	block_manager_split_region(&block_man, head, required_memory);

	print_all_statistics();

	return HEADER2PTR(head);
}

void *
realloc(void *ptr, size_t size)
{
	// Your code here
	printfmt("Accessing realloc\n");
	if (ptr == NULL) {
		printfmt("NULL ptr passed to realloc\n");
		return malloc(size);
	}
	if (size == 0) {
		free(ptr);
		return NULL;
	}

	// check the pointer was allocated with malloc
	if (!block_manager_is_valid_address(&block_man, ptr)) {
		printfmt("Trying to realloc a memory address that was not "
		         "malloc'd\n");
		return error();
	}

	// check the address that wants to be realloc'd belongs to an occupied region
	struct header *head_ptr = (struct header *) ptr;
	head_ptr -= 1;
	if (header_get_free(head_ptr) == true) {
		// Trying to realloc a free block should not be possible
		return error();
	}
	// check if the current memory region holds enough space for the realloc
	size_t current_memory_size = header_get_size(head_ptr);

	// case: trying to resize the same amount of memory
	if (size == current_memory_size) {
		return ptr;
	}

	// case: reducing memory size
	if (size < current_memory_size) {
		// attempt to split memory
		block_manager_split_region(&block_man, head_ptr, size);
		// print_all_statistics();
		// check if there was a split
		if (header_get_size(head_ptr) == size) {
			// a split was made
			// attempt coalescing
			header_coalesce(&block_man, header_get_next(head_ptr));
			// return memory region
			print_all_statistics();
			// return head_ptr+1;
		}
		// if there couldnt be a split, we still use the same region
		return head_ptr + 1;
	}

	// we don't have enough space in the current region.

	// first we look at the next region if it is free and the space is enough to hold
	// the current amount of requested memory. Check that the next region is not null

	struct header *next_region = header_get_next(head_ptr);
	if (next_region != NULL && header_get_free(next_region)) {
		// check if the combined memory is enough
		size_t combined_memory_available =
		        header_get_size(next_region) + sizeof(struct header) +
		        header_get_size(head_ptr);
		if (combined_memory_available >= size) {
			struct header *next_next_region =
			        header_get_next(next_region);
			head_ptr->next = next_next_region;
			header_put_size(head_ptr, combined_memory_available);
			block_manager_split_region(&block_man, head_ptr, size);
			print_all_statistics();
			// header_coalesce(&block_man, header_get_next(head_ptr));
			return head_ptr + 1;
		}
	}
	// next region cannot hold the requested memory
	// look if there is a region with enough memory in any of the currently assigned blocks
	struct header *new_region =
	        block_manager_find_free_region(&block_man, size);
	bool new_block_created = false;

	if (new_region == NULL) {
		// there is no free region in any of the blocks
		// create a new block with enough space
		if (!block_manager_create_block(&block_man, size, false)) {
			return error();
		}
		// there is a new block, now we get the region
		new_region = block_manager_find_free_region(&block_man, size);
		new_block_created = true;
	}
	// now all that is left is to copy the original contents
	if (memcpy(new_region + 1, ptr, current_memory_size) == NULL) {
		// fails to copy
		// if a new block was created it should be freed
		if (new_block_created) {
			block_manager_free_block(&block_man, new_region);
		}
		return error();
	}
	// set the new region as occupied
	header_occupy(new_region);
	block_manager_split_region(&block_man, new_region, size);
	// the memory was copied, so the previous region should be freed
	// the free that is done inside a realloc should be invisible to the
	// statistics presented to the user. As free increases the statistic by
	// one, we decrease preemptively by one the value
	free(ptr);
	// print_all_statistics();
	return new_region + 1;
}
