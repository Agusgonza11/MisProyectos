#ifndef _STATISTICS_H_
#define _STATISTICS_H_

#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

#include "region.h"
#include "printfmt.h"


// Debugging function
void region_print_status(struct region *region_ptr);

// Statistics function
void print_statistics(void);


#endif  // _STATISTICS_H_
