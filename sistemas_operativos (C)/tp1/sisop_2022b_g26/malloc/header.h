
//this is struct was not given by fisop
struct header{
    size_t size;
    int magic_number;
    bool free;
    struct header* next;
    int id;
    int belonging_block_id;
};

void header_occupy(struct header* head_ptr);
void header_free(struct header* head_ptr);

void header_occupy(struct header* head_ptr){
    head_ptr->free = false;
    printfmt("Occupied memory block: %d\n",head_ptr->belonging_block_id);
}

void header_free(struct header* head_ptr){
    head_ptr->free = true;
}

int header_get_id(struct header* head_ptr){
    return head_ptr->id;
}
size_t header_get_size(struct header* head_ptr){
    return head_ptr->size;
}

bool header_get_free(struct header* head_ptr){
    return head_ptr->free;
}
void header_put_size(struct header* head_ptr, size_t size){
    head_ptr->size = size;
}

//TODO: FIX CASE LAST REGION HAS NULL 
//FIX LEFT REGION FREE DOES NOT MERGE
void header_coalesce(struct header* head_ptr){
    struct header* next_header = head_ptr->next;
    struct header* next_next_header = next_header->next;
    size_t current_free_space = header_get_size(head_ptr);
    size_t next_free_space = header_get_size(next_header);
    size_t header_size = sizeof(struct header);
    size_t merged_space = current_free_space + next_free_space+ header_size;
    header_put_size(head_ptr, merged_space);
    head_ptr->next = next_next_header;
}


void print_header(struct header* head_ptr){
    if (head_ptr == NULL){
        return;
    }
   printfmt("////////////// Header id: %d //////////\n",head_ptr->id);
   printfmt("Size: %d   \n",head_ptr->size);
   printfmt("Magic number: %d   \n",head_ptr->magic_number);
   printfmt("Free:   %d\n", head_ptr->free);
   //printfmt("Id:  %d\n",head_ptr->id);
   printfmt("Next:   %d\n",head_ptr->next);
   printfmt("-----------------------------------------\n");
}

void header_print_current_and_following_headers(struct header* head_ptr){
    while(head_ptr != NULL){
        print_header(head_ptr);
        head_ptr = head_ptr->next;
    }
}

int header_get_block_id(struct header* head_ptr){
    return head_ptr->belonging_block_id;
}