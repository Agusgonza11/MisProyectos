#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

#include "printfmt.h"

#define HELLO "hello from test"
#define TEST_STRING "FISOP malloc is working!"

#define SEGUNDO_TEST_STRING "Segundo malloc is working!"

int
main(void)
{
	printfmt("%s\n", HELLO);

	char *var = malloc(16000);
	strcpy(var, TEST_STRING);
	printfmt("-- TEST MSG: %s --\n", var);
	char *el_grandote = malloc(33554000);
	strcpy(el_grandote, TEST_STRING);
	printfmt("%s\n", el_grandote);
	char *asd = malloc(1048300);
	strcpy(asd, SEGUNDO_TEST_STRING);
	printfmt("%s\n", asd);
	char *var_dos = malloc(16000);
	strcpy(var_dos, SEGUNDO_TEST_STRING);
	printfmt("-- TEST MSG: %s --\n", var_dos);
	free(asd);

	// char *dsa = malloc(13384);
	// strcpy(dsa, SEGUNDO_TEST_STRING);
	// printfmt("%s\n", dsa);
	// free(dsa);
	return 0;
}
