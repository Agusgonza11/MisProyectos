#include "header.h"

void
header_occupy(struct header *head_ptr)
{
	head_ptr->free = false;
	printfmt("- HEADER: Occupied memory block: %d\n",
	         head_ptr->belonging_block_id);
}

void
header_free(struct header *head_ptr)
{
	head_ptr->free = true;
}

int
header_get_id(struct header *head_ptr)
{
	return head_ptr->id;
}

size_t
header_get_size(struct header *head_ptr)
{
	return head_ptr->size;
}

bool
header_get_free(struct header *head_ptr)
{
	return head_ptr->free;
}

void
header_put_size(struct header *head_ptr, size_t size)
{
	head_ptr->size = size;
}


void
header_coalesce(struct block_manager *block_man, struct header *head_ptr)
{
	// struct header *next_header = head_ptr->next;
	// struct header *next_next_header = next_header->next;
	// size_t current_free_space = header_get_size(head_ptr);
	// size_t next_free_space = header_get_size(next_header);
	// size_t header_size = sizeof(struct header);
	// size_t merged_space = current_free_space + next_free_space + header_size;
	// header_put_size(head_ptr, merged_space);
	// head_ptr->next = next_next_header;

	int block_id = header_get_block_id(head_ptr);

	struct memory_block *mem_block =
	        block_manager_get_block(block_man, block_id);

	struct header *actual = mem_block->head;
	head_ptr->free = true;

	while (actual) {
		if (!actual->next)
			break;

		if (actual->id == head_ptr->id) {
			if (actual->next && actual->next->free) {
				actual->size += actual->next->size +
				                sizeof(struct header);
				actual->next = actual->next->next;
			}
			break;
		}

		if (actual->next->id == head_ptr->id) {
			if (actual->free) {
				actual->size += actual->next->size +
				                sizeof(struct header);
				actual->next = actual->next->next;

				if (actual->next && actual->next->free) {
					actual->size += actual->next->size +
					                sizeof(struct header);
					actual->next = actual->next->next;
				}
			} else {
				if (actual->next->next &&
				    actual->next->next->free) {
					actual->next->size +=
					        actual->next->next->size +
					        sizeof(struct header);
					actual->next->next =
					        actual->next->next->next;
				}
			}

			break;
		}

		actual = actual->next;
	}
}

void
print_header(struct header *head_ptr)
{
	if (head_ptr == NULL) {
		return;
	}
	printfmth("-----------------------------------\n");
	printfmth("| ID: %d | Header | %p |\n", head_ptr->id, head_ptr);
	printfmth("-----------------------------------\n");
	printfmth("| Size :  %d                     \n", head_ptr->size);
	printfmth("| Magic:  %d                     \n", head_ptr->magic_number);
	printfmth("| Free :  %s                   \n",
	          head_ptr->free ? "true" : "false");
	printfmth("| Next :  %p          \n", head_ptr->next);
	printfmth("-----------------------------------\n");
}

void
header_print_current_and_following_headers(struct header *head_ptr)
{
	while (head_ptr != NULL) {
		print_header(head_ptr);
		head_ptr = head_ptr->next;
	}
}

int
header_get_block_id(struct header *head_ptr)
{
	return head_ptr->belonging_block_id;
}


struct header *
header_get_next(struct header *head_ptr)
{
	return head_ptr->next;
}