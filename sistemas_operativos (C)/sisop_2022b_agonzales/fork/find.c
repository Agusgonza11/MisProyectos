#define _GNU_SOURCE
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include <dirent.h>
#include <fcntl.h>

bool autorizar_impresion(struct dirent *lib, char *buscado, bool capitalizado);
void find(int libreria_abierta,
          char *buscado,
          bool capitalizado,
          char buffer[PATH_MAX]);

bool
autorizar_impresion(struct dirent *lib, char *buscado, bool capitalizado)
{
	bool autoriza_impresion = false;
	if (capitalizado) {
		if (strcasestr(lib->d_name, buscado))
			autoriza_impresion = true;
	} else {
		if (strstr(lib->d_name, buscado))
			autoriza_impresion = true;
	}
	return autoriza_impresion;
}

void
find(int libreria_abierta, char *buscado, bool capitalizado, char buffer[PATH_MAX])
{
	DIR *libreria = fdopendir(libreria_abierta);
	if (libreria == NULL)
		return;
	struct dirent *lib = readdir(libreria);
	while (lib != NULL) {
		char buffer_actual[PATH_MAX];
		strcpy(buffer_actual, buffer);
		if (strcmp(lib->d_name, ".") != 0 &&
		    strcmp(lib->d_name, "..") != 0 && lib->d_type == DT_DIR) {
			if (strlen(buffer_actual) > 0)
				strcat(buffer_actual, "/");
			strcat(buffer_actual, lib->d_name);
			if (autorizar_impresion(lib, buscado, capitalizado)) {
				printf("%s\n", buffer_actual + 4);
			}
			int nueva_libreria =
			        openat(dirfd(libreria), lib->d_name, O_DIRECTORY);
			find(nueva_libreria, buscado, capitalizado, buffer_actual);
		} else if (autorizar_impresion(lib, buscado, capitalizado)) {
			printf("%s/%s\n", buffer_actual + 4, lib->d_name);
		}
		lib = readdir(libreria);
	}
	closedir(libreria);
}

int
main(int argc, char *argv[])
{
	if (argc >= 4 || argc <= 1)
		return -1;

	DIR *libreria = opendir(".");
	if (libreria == NULL)
		return -1;

	char buffer[PATH_MAX];
	if (argc == 3 && strcmp(argv[1], "-i") == 0) {
		find(dirfd(libreria), argv[2], true, buffer);
	} else if (argc == 2) {
		find(dirfd(libreria), argv[1], false, buffer);
	}
	closedir(libreria);
	return 0;
}
