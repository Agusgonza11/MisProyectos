#include <sys/mman.h>
#include <string.h>
#include "printfmt.h"
#include "header.h"
#define MAGIC_NUMBER 777
#define MIN_REGION_SIZE 8 //TO BE DETERMINED. PLACEHOLDER
#define INITIAL_BLOCK_SIZE 16384

struct memory_block {
    void* mem_ptr;
    size_t mem_size;
    struct header* head;
    int issued_regions; //starts with region 0
    int block_id;
    struct memory_block* next;
};

void memory_block_print_first_header(struct memory_block* ptr);
int memory_block_create(struct memory_block* block_ptr, int block_id, size_t size, bool calloc);
static struct header* memory_block_find_free_region(struct memory_block* block,size_t size);
void memory_block_split(struct memory_block* block, int id, size_t requested_size);
struct memory_block* memory_block_get_next(struct memory_block* block);
size_t memory_block_get_size(struct memory_block* block);
void* memory_block_get_memory(struct memory_block* block);
int memory_block_get_id(struct memory_block* block);
void memory_block_set_next(struct memory_block* block, struct memory_block* next);

void memory_block_set_next(struct memory_block* block, struct memory_block* next){
    block->next = next;
}

int memory_block_get_id(struct memory_block* block){
    return block->block_id;
}


void* memory_block_get_memory(struct memory_block* block){
    return block->mem_ptr;
}


size_t memory_block_get_size(struct memory_block* block){
    return block->mem_size;
}


struct memory_block* memory_block_get_next(struct memory_block* blk){
    return blk->next;
}



void memory_block_print_mem_position(struct memory_block* block){
    printfmt("Position of mem_ptr: %d\n",block->mem_ptr);
}

//for debugging
void memory_block_print_header_of_mem_ptr(struct memory_block *ptr){
    struct header * head_ptr = (struct header*)ptr->mem_ptr;
    print_header(head_ptr);
}



int memory_block_create(struct memory_block* block_ptr, int block_id, size_t size, bool calloc){
    //assign a 16Kib (16384 bytes) sized block of memory
    int flags = MAP_PRIVATE | MAP_ANONYMOUS;
    void * ptr = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, -1,0);
    if (ptr == MAP_FAILED){
        printfmt("MAP FAILED\n");
        //memory assignment failed
        return -1;
    }

    if (calloc){
        char* aux_ptr = (char*) ptr;
        for(int i=0; i<size; i++){
            *(aux_ptr+i) = 0;
        }
    }
    block_ptr->mem_ptr = ptr;
    block_ptr->mem_size = size;
    struct header first_header = {size - sizeof(struct header), MAGIC_NUMBER, true, NULL, 0, block_id, };
    if (memcpy(block_ptr->mem_ptr, &first_header, sizeof(first_header)) == NULL){
        printfmt("memcpy failed\n");
    } else{
        printfmt("memcpy worked \n");
    }
    block_ptr->head = (struct header*) block_ptr->mem_ptr;
    block_ptr->issued_regions = 1;
    block_ptr->block_id = block_id;
    block_ptr->next = NULL;
    return 0;
}



void memory_block_split(struct memory_block* block, int id, size_t requested_size){
    //printfmt("Value of id: %d\n",id);
    struct header* head_ptr = block->head;
    while(header_get_id(head_ptr) != id){
        head_ptr = head_ptr->next;
    }
    //printfmt("Found the header id \n");
    size_t remaining_size = header_get_size(head_ptr)-requested_size;
    //printfmt("Remaining size: %d\n",remaining_size);
    //printfmt("Size available described in header: %d\n",header_get_size(head_ptr));
    //printfmt("Requested size: %d\n",requested_size);
    struct header* next_header = head_ptr->next;
    //check if the memory of the current region can be split
    if (remaining_size >= MIN_REGION_SIZE + sizeof(struct header)){
        header_put_size(head_ptr, requested_size);
        //print_header(head_ptr);
        struct header split_header = {remaining_size-sizeof(struct header), MAGIC_NUMBER, true, next_header, block->issued_regions, block->block_id};
        block->issued_regions++;
        //copy the new header in the free space given by mmap
        size_t start_of_next_header = (char*)head_ptr+header_get_size(head_ptr)+sizeof(struct header);
        head_ptr->next = start_of_next_header;
        //printfmt("Position in the mmap memory of the beginning of the next header:%d\n",start_of_next_header);
        if (memcpy(start_of_next_header, &split_header, sizeof(struct header)) == -1){
            printfmt("Memcpy for the remaining region failed\n");
        }
    }
    //header_print_current_and_following_headers(block->head);
}


void memory_block_print_first_header(struct memory_block* ptr){
    print_header(ptr->head);
}

static struct header* memory_block_find_free_region(struct memory_block* block,size_t size){
    struct header* head = block->head;
    #ifdef FIRST_FIT
	// Your code here for "first fit"
    while(head!=NULL){
        if (head->size >= size && head->free == true){
            return head;
        }
        head = head->next;
    }
    printfmt("Find free region did not \n");
    //return head;
    #endif

    #ifdef BEST_FIT
	// Your code here for "best fit"
    size_t lowest_size = header_get_size(head);
    struct header* head_to_return = head;
    while(head!=NULL){
        if (head->size >= size && head->free == true){
            //possible candidate, compare size
            if (lowest_size > header_get_size(head)){
                lowest_size = header_get_size(head);
                head_to_return = head;
            }
            head=head->next;
        }
    }
    return head_to_return;


    #endif


    //PUTTING HERE THE CODE FOR FIRST_FIT. DELETE LATER
    while(head!=NULL){
        if (head->size >= size && head->free == true){
            printfmt("Found free region in block: %d\n",head->belonging_block_id);
            return head;
        }
        //print_header(head);
        head = head->next;
    }
    printfmt("Find free region did not find a free region with matching requirements\n");

	return head;
}