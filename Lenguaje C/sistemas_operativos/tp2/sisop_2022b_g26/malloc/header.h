#ifndef _HEADER_H_
#define _HEADER_H_

#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

#include "printfmt.h"
#include "block_manager.h"

#define HEADER2PTR(r) ((r) + 1)
#define PTR2HEADER(ptr) ((struct header *) (ptr) -1)

// this is struct was not given by fisop
struct header {
	size_t size;
	int magic_number;
	bool free;
	struct header *next;
	int id;
	int belonging_block_id;
};

void header_occupy(struct header *head_ptr);

void header_free(struct header *head_ptr);

int header_get_id(struct header *head_ptr);

size_t header_get_size(struct header *head_ptr);

bool header_get_free(struct header *head_ptr);

void header_put_size(struct header *head_ptr, size_t size);

void header_coalesce(struct block_manager *man_ptr, struct header *head_ptr);

void print_header(struct header *head_ptr);

void header_print_current_and_following_headers(struct header *head_ptr);

int header_get_block_id(struct header *head_ptr);

struct header* header_get_next(struct header* head_ptr);

#endif  // _HEADER_H_
