#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

#define LECTURA 0
#define ESCRITURA 1

int
main()
{
	int primer_fds[2];
	int segundo_fds[2];
	int primer_pipe = pipe(primer_fds);
	int segundo_pipe = pipe(segundo_fds);

	if (primer_pipe < 0 || segundo_pipe < 0)
		return -1;

	printf("Hola, soy PID %d:\n", getpid());

	printf(" - primer pipe me devuelve: [%d, %d]\n",
	       primer_fds[LECTURA],
	       primer_fds[ESCRITURA]);
	printf(" - segundo pipe me devuelve: [%d, %d]\n",
	       segundo_fds[LECTURA],
	       segundo_fds[ESCRITURA]);
	printf("\n");

	int proceso = fork();

	if (proceso < 0)
		return -1;
	if (proceso != 0) {
		close(primer_fds[LECTURA]);
		close(segundo_fds[ESCRITURA]);

		int numero_aleatorio = random();
		printf("Donde fork me devuelve %d:\n", proceso);
		printf("  - getpid me devuelve:  %d\n", getpid());
		printf("  - getppid me devuelve: %d\n", getppid());
		printf("  - random me devuelve: %d\n", numero_aleatorio);
		printf("  - envio valor %d a traves de fd=%d\n",
		       numero_aleatorio,
		       primer_fds[ESCRITURA]);
		printf("\n");

		if (write(primer_fds[ESCRITURA],
		          &numero_aleatorio,
		          sizeof(numero_aleatorio)) < 0)
			return -1;

		int recibido;
		if (read(segundo_fds[LECTURA], &recibido, sizeof(recibido)) < 0)
			return -1;
		printf("Hola, de nuevo PID %d:\n", getpid());
		printf("  - recibi valor %d via fd=%d\n",
		       recibido,
		       segundo_fds[LECTURA]);

		close(primer_fds[ESCRITURA]);
		close(segundo_fds[LECTURA]);
	} else {
		close(primer_fds[ESCRITURA]);
		close(segundo_fds[LECTURA]);

		int recibido;
		if (read(primer_fds[LECTURA], &recibido, sizeof(recibido)) < 0)
			return -1;
		printf("Donde fork me devuelve 0:\n");
		printf("  - getpid me devuelve:  %d\n", getpid());
		printf("  - getppid me devuelve: %d\n", getppid());
		printf("  - recibo valor %d via fd=%d\n",
		       recibido,
		       primer_fds[LECTURA]);
		printf("  - reenvio valor en fd=%d y termino\n",
		       segundo_fds[ESCRITURA]);
		printf("\n");

		if (write(segundo_fds[ESCRITURA], &recibido, sizeof(recibido)) < 0)
			return -1;

		close(primer_fds[LECTURA]);
		close(segundo_fds[ESCRITURA]);
	}
	return 0;
}