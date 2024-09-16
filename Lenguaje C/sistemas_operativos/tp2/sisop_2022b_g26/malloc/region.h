#ifndef _REGION_H_
#define _REGION_H_

#define ALIGN4(s) (((((s) -1) >> 2) << 2) + 4)
#define REGION2PTR(r) ((r) + 1)
#define PTR2REGION(ptr) ((struct region *) (ptr) -1)


struct region {
	bool free;
	size_t size;
	struct region *next;
};


#endif  // _REGION_H_
