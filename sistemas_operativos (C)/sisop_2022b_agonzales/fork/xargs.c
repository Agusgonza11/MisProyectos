#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>

#ifndef NARGS
#define NARGS 4
#endif

int
main(int argc, char *argv[])
{
	if (argc != 2)
		return -1;
	char *lista_argumentos[NARGS + 2];
	for (int i = 0; i < NARGS + 2; i++) {
		lista_argumentos[i] = NULL;
	}
	lista_argumentos[0] = argv[1];
	char *linea = NULL;
	size_t largo = 0;
	int contador = 0;
	ssize_t lector = 1;
	while (lector > 0) {
		lector = getline(&linea, &largo, stdin);
		int posicion = (contador % NARGS) + 1;
		linea[lector - 1] = '\0';
		// if(strlen(linea) == 0) linea = NULL;
		if (lector != EOF)
			lista_argumentos[posicion] = linea;
		linea = NULL;
		contador++;
		if (lector < 0 || (contador % NARGS == 0)) {
			int proceso = fork();
			if (proceso < 0)
				return -1;
			if (proceso == 0) {
				if (execvp(argv[1], lista_argumentos))
					return -1;
			}
			if (wait(NULL) < 0)
				return -1;
		}
	}
	return 0;
}
