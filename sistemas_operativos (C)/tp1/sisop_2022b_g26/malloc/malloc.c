#define _DEFAULT_SOURCE

#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <unistd.h>

#include "malloc.h"
#include "printfmt.h"
//#include "memory_block.h"
#include "block_manager.h"
#include "region.h"
#include <stdio.h>

#define ALIGN4(s) (((((s) -1) >> 2) << 2) + 4)
#define REGION2PTR(r) ((r) + 1)
#define PTR2REGION(ptr) ((struct region *) (ptr) -1)


#define SMALL_BLOCK_SIZE 16384
#define MEDIUM_BLOCK_SIZE 1048576
#define LARGE_BLOCK_SIZE 33554432


struct region {
	bool free;
	size_t size;
	struct region *next;
};

// debugging function
void
region_print_status(struct region *region_ptr)
{
	printfmt("-------------Region: Status-------------\n");
	if (region_ptr->free == true) {
		printfmt("Bool: true\n");
	} else {
		printfmt("Bool: false\n");
	}
	printfmt("Size: %d\n", region_ptr->size);
	printfmt("Next region position: %d\n", region_ptr->next);
	printfmt("---------------Region: end --------------\n");
}


struct region *region_free_list = NULL;


// struct memory_block block;
struct block_manager block_man;

int amount_of_mallocs = 0;
int amount_of_frees = 0;
int requested_memory = 0;

static void
print_statistics(void)
{
	printfmt("mallocs:   %d\n", amount_of_mallocs);
	printfmt("frees:     %d\n", amount_of_frees);
	printfmt("requested: %d\n", requested_memory);
}

// finds the next free region
// that holds the requested size
//
static struct region *
find_free_region(size_t size)
{
	struct region *next = region_free_list;

#ifdef FIRST_FIT
	// Your code here for "first fit"
	// should look for the first free region that is big enough to contain the size of memory
	// that is being asked for. The size should be (size_requested + sizeof(Header))
	size_t true_requested_size = size + sizeof(header_t);
	while (next != NULL) {
		if ((next->free == true) && (next->size >= true_requested_size)) {
			// found a free region with enough space
			return next;
		}
		// region yet not found, search for the next region
		next = next->next;
	}
	// no free regions with enough space were found
	return NULL;
#endif

#ifdef BEST_FIT
	// Your code here for "best fit"
#endif

	return next;
}

static struct region *
grow_heap(size_t size)
{
	// finds the current heap break
	struct region *curr = (struct region *) sbrk(0);

	// allocates the requested size
	struct region *prev =
	        (struct region *) sbrk(sizeof(struct region) + size);

	// verifies that the returned address
	// is the same that the previous break
	// (ref: sbrk(2))
	assert(curr == prev);

	// verifies that the allocation
	// is successful
	//
	// (ref: sbrk(2))
	if (curr == (struct region *) -1) {
		return NULL;
	}

	// first time here
	if (!region_free_list) {
		region_free_list = curr;
		atexit(print_statistics);
	}

	curr->size = size;
	curr->next = NULL;
	curr->free = false;

	return curr;
}

void *
malloc(size_t size)
{
	// struct region *next;
	// aligns to multiple of 4 bytes
	size = ALIGN4(size);

	// updates statistics
	amount_of_mallocs++;
	requested_memory += size;

	/*
	next = find_free_region(size);

	if (!next) {
	        next = grow_heap(size);
	}*/


	if (amount_of_mallocs == 1) {
		/*
		if (memory_block_create(&block) == -1){
		        //failed to assign the initial memory block
		        printfmt("Memory assignment failed\n");
		        return NULL;
		}*/
		if (block_manager_initialize(&block_man) == true) {
			printfmt("First call to malloc. Trying to assign 16 "
			         "Kib memory\n");
			// check if the requested memory is bigger than the biggest possible block
			if (size > LARGE_BLOCK_SIZE) {
				amount_of_mallocs--;
				printfmt("Requested memory larger than the "
				         "maximum possible\n");
				return NULL;
			}
			if (block_manager_create_block(&block_man,
			                               SMALL_BLOCK_SIZE,
			                               true) != true) {
				printfmt("Failed first block allocation\n");
				return NULL;
			}
		}
	}
	// block_manager_print_status(&block_man);

	// struct header* head = memory_block_find_free_region(&block,size);
	struct header *head = block_manager_find_free_region(&block_man, size);
	// return NULL;

	if (head == NULL) {
		printfmt("Find free region failed. Attempting to create a new "
		         "block of memory\n");
		// attempt to create a new block and try again
		size_t min_memory_required =
		        block_manager_get_min_memory_required(&block_man, size);
		if (block_manager_create_block(
		            &block_man, min_memory_required, true) != true) {
			// failed to create a new block
			return NULL;
		}
		printfmt("Created a new block of memory, searching for a "
		         "region in the new block of memory\n");
		head = block_manager_find_free_region(&block_man, size);
	}
	// change header to not free
	header_occupy(head);
	// print_header(head);

	// split the memory, creating a new region
	// memory_block_split(&block, header_get_id(head), size);
	block_manager_split_region(&block_man, head, size);
	print_header(head);
	/*
	block_manger_print_status(&block_man);*/


	return head + 1;


	// region_print_status(next);
	// Your code here
	//
	// hint: maybe split free regions?
}

void
free(void *ptr)
{
	// updates statistics
	amount_of_frees++;
	/*
	        struct region *curr = PTR2REGION(ptr);
	        assert(curr->free == 0);

	        curr->free = true;
	*/

	struct header *head = (struct header *) ptr - 1;
	assert(head->free == 0);
	head->free = true;

	// attempt to free the block
	block_manager_free_block(&block_man, head);
	// region coalescing
	struct header *next_header = head->next;
	if (next_header != NULL && header_get_free(next_header)) {
		header_coalesce(head);
	}

	print_statistics();
	// Your code here
	//
	// hint: maybe coalesce regions?
}

void *
calloc(size_t nmemb, size_t size)
{
	// Your code here

	size_t required_memory = nmemb * size;
	requested_memory = ALIGN4(size);

	// updates statistics
	amount_of_mallocs++;
	requested_memory += size;

	if (amount_of_mallocs == 1) {
		if (block_manager_initialize(&block_man) == true) {
			printfmt("First call to malloc. Trying to assign 16 "
			         "Kib memory\n");
			// check if the requested memory is bigger than the biggest possible block
			if (size > LARGE_BLOCK_SIZE) {
				amount_of_mallocs--;
				printfmt("Requested memory larger than the "
				         "maximum possible\n");
				return NULL;
			}
			if (block_manager_create_block(&block_man,
			                               SMALL_BLOCK_SIZE,
			                               true) != true) {
				printfmt("Failed first block allocation\n");
				return NULL;
			}
		}
	}
	struct header *head = block_manager_find_free_region(&block_man, size);

	if (head == NULL) {
		printfmt("Find free region failed. Attempting to create a new "
		         "block of memory\n");
		// attempt to create a new block and try again
		size_t min_memory_required =
		        block_manager_get_min_memory_required(&block_man, size);
		if (block_manager_create_block(
		            &block_man, min_memory_required, true) != true) {
			// failed to create a new block
			return NULL;
		}
		printfmt("Created a new block of memory, searching for a "
		         "region in the new block of memory\n");
		head = block_manager_find_free_region(&block_man, size);
	}
	// change header to not free
	header_occupy(head);

	// split the memory, creating a new region
	block_manager_split_region(&block_man, head, size);
	print_header(head);
	return head + 1;
	// return NULL;
}

void *
realloc(void *ptr, size_t size)
{
	if (size > sizeof(ptr))
		return NULL;
	if (size == 0) {
		if (ptr)
			free(ptr);
		return NULL;
	}
	if (!ptr) {
		return malloc(size);
	}

	//void *res = malloc(size);
	//memcpy(res, ptr, sizeof(ptr));

	//Aqui basicamente hay que hacer un malloc y al principio de esa memoria copiarlo lo de ptr
	size = ALIGN4(size);
	requested_memory += size;
	struct header *head = block_manager_find_free_region(&block_man, size);

	if (head == NULL) {
		printfmt("Find free region failed. Attempting to create a new "
		         "block of memory\n");
		// attempt to create a new block and try again
		size_t min_memory_required = block_manager_get_min_memory_required(&block_man, size);
		if (block_manager_create_block(
		            &block_man, min_memory_required, true) != true) {
			// failed to create a new block
			return NULL;
		}
		printfmt("Created a new block of memory, searching for a "
		         "region in the new block of memory\n");
		head = block_manager_find_free_region(&block_man, size);
	}

	memcpy(head, ptr, sizeof(ptr));
	header_occupy(head);

	block_manager_split_region(&block_man, head, size);
	print_header(head);

	free(ptr);

	return head + 1;
}
