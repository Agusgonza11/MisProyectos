#include "statistics.h"

int amount_of_frees = 0;
int requested_memory = 0;
int amount_of_mallocs = 0;


void
region_print_status(struct region *region_ptr)
{
	printfmt("------------- Region: Status -------------\n");
	printfmt("Bool: %s\n", region_ptr->free ? "true" : "false");
	printfmt("Size: %d\n", region_ptr->size);
	printfmt("Next: %p\n", region_ptr->next);
	printfmt("-------------- Region: end ---------------\n");
}


void
print_statistics(void)
{
	printfmt("mallocs:   %d\n", amount_of_mallocs);
	printfmt("frees:     %d\n", amount_of_frees);
	printfmt("requested: %d\n", requested_memory);
}