#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>

#define LECTURA 0
#define ESCRITURA 1

void eliminar_no_primos(int fds[2]);

void
eliminar_no_primos(int fds[2])
{
	close(fds[ESCRITURA]);
	int primo_actual;

	if (read(fds[LECTURA], &primo_actual, sizeof(primo_actual)) <= 0)
		return;

	printf("primo %d\n", primo_actual);

	int otro_fds[2];
	int otro_pipe = pipe(otro_fds);
	if (otro_pipe < 0)
		return;

	int otro_proceso = fork();

	if (otro_proceso < 0)
		return;
	if (otro_proceso != 0) {
		close(otro_fds[LECTURA]);

		int recibido;
		while (read(fds[LECTURA], &recibido, sizeof(recibido)) > 0) {
			if (recibido % primo_actual != 0) {
				if (write(otro_fds[ESCRITURA],
				          &recibido,
				          sizeof(recibido)) < 0)
					return;
			}
		}
		close(otro_fds[ESCRITURA]);
		close(fds[LECTURA]);
		wait(NULL);
		return;
	} else {
		close(otro_fds[ESCRITURA]);
		close(fds[LECTURA]);
		eliminar_no_primos(otro_fds);
		close(otro_fds[LECTURA]);
		return;
	}
}

int
main(int argc, char *argv[])
{
	if (argc != 2)
		return -1;

	int numero_ingresado = atoi(argv[1]);
	if (numero_ingresado <= 1)
		return -1;

	int fds[2];
	int primer_pipe = pipe(fds);
	if (primer_pipe < 0)
		return -1;

	int proceso = fork();

	if (proceso < 0)
		return -1;
	if (proceso != 0) {
		close(fds[LECTURA]);

		for (int i = 2; i <= numero_ingresado; i++) {
			if (write(fds[ESCRITURA], &i, sizeof(i)) < 0)
				return -1;
		}

		close(fds[ESCRITURA]);
		wait(NULL);
	} else {
		eliminar_no_primos(fds);
	}
	return 0;
}
