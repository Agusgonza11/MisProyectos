#include <string>
#include <iostream>
#include <fstream>
#include "wordscounter.h"

#define SUCCESS 0
#define FAIL 1

int main(int argc, char* argv[]) {
    Wordscounter counter;
    std::ifstream input;
    if (argc > 1) {
        input.open(argv[1]);
        if (!input.is_open()) {
        	return FAIL;
        }
        counter.process(input);
    } else {
        counter.process(std::cin);
    }
    size_t words = counter.get_words();
    std::cout << words << std::endl;
    return SUCCESS;
}
