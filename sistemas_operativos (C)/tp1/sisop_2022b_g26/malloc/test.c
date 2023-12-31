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
	char *var = malloc(100);

	strcpy(var, TEST_STRING);

	printfmt("%s\n", var);

	char *twovar = malloc(200);
	strcpy(twovar, SEGUNDO_TEST_STRING);
	printfmt("%s\n", twovar);
	free(twovar);
	free(var);

	return 0;
}
