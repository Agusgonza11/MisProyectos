
#define SMALL_BLOCK_SIZE 16384
#define MEDIUM_BLOCK_SIZE 1048576
#define LARGE_BLOCK_SIZE 33554432

#define UPPER_LIMIT_SIZE 100663296 //it is three times the LARGE_BLOCK_SIZE 

#ifndef MEMORY_BLOCK
#include "memory_block.h"
#endif
#include <sys/mman.h>




struct block_manager{
    int issued_blocks; //los usamos como id para cada bloque
    struct memory_block*  head_block; //LISTA ENLAZADA DE BLOQUES ES EL PRIMERO
    size_t memory_for_block_structs; //es la memoria para guardar los structs bloques
    size_t total_memory_in_blocks;
    void* mem_ptr; //la memoria donde se guarda donde se guardan los structs bloques
};

bool block_manager_initialize(struct block_manager* man_ptr){
    size_t amount_of_memory = SMALL_BLOCK_SIZE /2 ;
    void * ptr = mmap(NULL, INITIAL_BLOCK_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1,0);
    if (ptr == MAP_FAILED){
        printfmt("MAP FAILED in block manager\n");
        //memory assignment failed
        return false;
    }
    man_ptr->mem_ptr = ptr;
    man_ptr->memory_for_block_structs = amount_of_memory;
    man_ptr->total_memory_in_blocks = 0;
    man_ptr->head_block = NULL;
    return true;
}


bool block_manager_create_block(struct block_manager* man_ptr, size_t size, bool calloc){
    struct block_manager block;
    //check if creating the new block exceeds the maximum allowed memory
    if (man_ptr->total_memory_in_blocks + size > UPPER_LIMIT_SIZE){
        return false;
    }
    if (memory_block_create(&block, man_ptr->issued_blocks, size,calloc)  == -1){
        return false;
    }
    man_ptr->issued_blocks++;
    struct memory_block* last_block = man_ptr->head_block;
    if(last_block == NULL){
        //FIRST BLOCK ALLOCATION
        memcpy(man_ptr->mem_ptr, &block , sizeof(block));
        man_ptr->head_block = man_ptr->mem_ptr;
    } else{
        //THERE WAS ALREADY AN EXISTING BLOCK 
        while(last_block->next != NULL){
            last_block = last_block->next;
        }
        size_t address_of_next_block_struct = last_block+1;
        last_block->next = address_of_next_block_struct;
        memcpy(address_of_next_block_struct, &block, sizeof(struct memory_block));
    }
    man_ptr->total_memory_in_blocks+=size;
    return true;
}


struct header* block_manager_find_free_region(struct block_manager* man, size_t size){
    printfmt("Block manager issued %d blocks. Attempting to search for a free region of size: %d\n",man->issued_blocks, size);
    struct memory_block* blk = man->head_block;
    //printfmt("Value of blk: %d\n",blk);
    //print_header(blk->head);
    struct header* aux_ptr = NULL;
    while (blk!=NULL){
        printfmt("Searching block %d for free regions\n",blk->block_id);
        aux_ptr = (void*) memory_block_find_free_region(blk, size);
        if (aux_ptr != NULL){
            break;
        }
        blk = blk->next;
    }
    //printfmt("Function block_manager_find_free_region end\n");
    return aux_ptr;
}

struct memory_block* block_manager_get_block(struct block_manager* man, int id){
    struct memory_block* curr_block = man->head_block;
    while(curr_block != NULL){
        //printfmt("Current block checked id: %d\n",curr_block->block_id);
        if (curr_block->block_id == id){
            return curr_block;
        }
        curr_block = curr_block->next;
    }
    return curr_block;
}

void block_manager_split_region(struct block_manager* man, struct header* head, size_t size){
    //printfmt("********Function: block_manager_split_region\n");
    size_t block_id = header_get_block_id(head);
    //printfmt("********Got block id\n");
    int header_id = header_get_id(head);
    //printfmt("********Got header id\n");
    struct memory_block* target_block = block_manager_get_block(man, block_id);
    memory_block_split(target_block, header_id, size);
}



void block_manager_print_status(struct block_manager* man){
    printfmt("********************** Block Manager Status***********************\n");
    printfmt("Block 0\n");
    struct memory_block* block = man->head_block;
    struct header* head = block->head;
    header_print_current_and_following_headers(head);
    printfmt("********************** Block manager END**************************\n");
}

size_t block_manager_get_min_memory_required(struct block_manager* man, size_t size){
    if (size >  SMALL_BLOCK_SIZE){
        return SMALL_BLOCK_SIZE;
    }
    if (size > MEDIUM_BLOCK_SIZE){
        return MEDIUM_BLOCK_SIZE;
    }
    return LARGE_BLOCK_SIZE;
}

//NO CONTEMPLA QUE SE LIBERA EL ULTIMO BLOQUE
void block_manager_free_block(struct block_manager* man, struct header* head){
    int block_id = header_get_block_id(head);
    struct memory_block* mem_block = block_manager_get_block(man,block_id);
    struct memory_block* next_mem_block = memory_block_get_next(mem_block);
    struct memory_block* head_mem_block = man->head_block;
    //check if the block has more than one region
    if (mem_block->head->next == NULL){
        //there is only one block. 
        size_t size_to_liberate = memory_block_get_size(mem_block);
        //it is necessary to change the "next" mappings in the previous block
        //if there is one. 
        //CASE 1: the first block is the one getting erased
        if (memory_block_get_id(head_mem_block) == block_id){
            //change the head block 
            man->head_block = next_mem_block;
        } else{
            //CASE 2: the block getting erased is not the first one
            while (memory_block_get_id(head_mem_block->next) != block_id ){
                head_mem_block = memory_block_get_next(head_mem_block);
            }
            memory_block_set_next(head_mem_block, next_mem_block);
        }
        //update the memory currently allocated
        man->total_memory_in_blocks-= size_to_liberate;
        int munmap_result = munmap(memory_block_get_memory(mem_block),size_to_liberate);
        //printfmt("Munmap result: %d\n",munmap_result);
    }
}