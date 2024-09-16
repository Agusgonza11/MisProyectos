#ifndef _MALLOC_H_
#define _MALLOC_H_

#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

#include "header.h"
#include "block_manager.h"
#include "printfmt.h"
#include "region.h"
#include "statistics.h"

extern int amount_of_mallocs;
extern int amount_of_frees;
extern int requested_memory;

#define HEADER2PTR(r) ((r) + 1)
#define PTR2HEADER(ptr) ((struct header *) (ptr) -1)


void *malloc(size_t size);

void free(void *ptr);

void *calloc(size_t nmemb, size_t size);

void *realloc(void *ptr, size_t size);

#endif  // _MALLOC_H_
