#define FUSE_USE_VERSION 30

#include <fuse.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/file.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>

#define TRUE 1
#define FALSE 0

#define DIRECTORIOS 10
#define TAM_NOMBRE_DIR 20
#define ARCHIVOS 20
#define TAM_NOMBRE_ARCH 20
#define TAM_ARCHIVOS_CONT 500

#define TAM_ARCH_PERSISTENCIA 600

int quedarme_mayor(const int x, const int y){
	int resultado = 0;
	resultado = (x > y) ?x :y;
	return resultado;
}

typedef struct disco {
	char directorios[DIRECTORIOS][TAM_NOMBRE_DIR];
	char archivos[ARCHIVOS][TAM_NOMBRE_ARCH];
	char contenidos[ARCHIVOS][TAM_ARCHIVOS_CONT];
	char tabla_arch_dir[ARCHIVOS][TAM_NOMBRE_DIR];
	int dir_actual; //Proximo directorio libre
	int ar_actual; //Proximo archivo libre
	int cant_directorios; //Cantidad de directorios
	int cant_archivos; //Cantidad de archivos
	char nombre[TAM_NOMBRE_ARCH];
} disco_t;

disco_t* crear_disco(char *nombre_disco){
	disco_t* disco = malloc(sizeof(disco_t));
	if(!disco) return NULL;
	disco->dir_actual = 0;
	disco->ar_actual = 0;
	disco->cant_directorios = 0;
	disco->cant_archivos = 0;
	strcpy(disco->nombre, nombre_disco);
	return disco;
}

void actualizar_indice_archivos(disco_t* disco){
	for(int i = 0; i < disco->ar_actual; i++){
		if(!strcmp("", disco->archivos[i])){
			disco->ar_actual = i;
			return;
		}
	}
}

void actualizar_indice_directorios(disco_t* disco){
	for(int i = 0; i<= disco->dir_actual; i++){
		if(!strcmp("", disco->directorios[i]))
			disco->dir_actual = i;
	}
}

int agregar_archivo(disco_t* disco, const char *nombre){

	if(disco->cant_archivos >= ARCHIVOS)
		return -ENOMEM;
	if(disco->ar_actual > disco->cant_archivos && disco->ar_actual >= ARCHIVOS)
		actualizar_indice_archivos(disco);
	strcpy(disco->archivos[disco->ar_actual], nombre);
	strcpy(disco->contenidos[disco->ar_actual], "");
	strcpy(disco->tabla_arch_dir[disco->ar_actual], "/");

	disco->ar_actual++;
	disco->cant_archivos++;
	return EXIT_SUCCESS;
}

int agregar_archivo_a_directorio(disco_t* disco, const char *nombre, int barra_n){
	if(disco->cant_archivos >= ARCHIVOS)
		return -ENOMEM;
	if(disco->ar_actual > disco->cant_archivos && disco->ar_actual >= ARCHIVOS)
		actualizar_indice_archivos(disco);
	char directorio[TAM_NOMBRE_ARCH] = "";
	char archivo[TAM_NOMBRE_ARCH] = "";

	strncpy(directorio, nombre, barra_n);
	strcpy(archivo, nombre + 1 + barra_n);

	strcpy(disco->archivos[disco->ar_actual], archivo);
	strcpy(disco->contenidos[disco->ar_actual], "");
	strcpy(disco->tabla_arch_dir[disco->ar_actual], directorio);

	disco->ar_actual++;
	disco->cant_archivos++;
	return EXIT_SUCCESS;
}

int existe_archivo(const disco_t* disco, const char *nombre){
	nombre++;
	int empieza_directorio = -1;
	for(size_t i = 0; i < strlen(nombre); i++){
		if(nombre[i] == '/'){
			empieza_directorio = i;
			break;
		}
	}
	if(empieza_directorio != -1){
		char directorio[TAM_NOMBRE_ARCH] = "";
		strncpy(directorio, nombre, empieza_directorio);
		int iterador_arch = quedarme_mayor(disco->ar_actual, disco->cant_archivos);
		for(int i = 0; i < iterador_arch; i++){
			if(!strcmp(nombre + empieza_directorio + 1, disco->archivos[i]) && !strcmp(directorio, disco->tabla_arch_dir[i]))
				return TRUE;
		}	
	} else {
		int iterador_arch = quedarme_mayor(disco->ar_actual, disco->cant_archivos);
		for(int i = 0; i < iterador_arch; i++){
			if(!strcmp(nombre, disco->archivos[i]))
				return TRUE;
		}
	}
	return FALSE;
}

int obtener_archivo(const disco_t* disco, const char *nombre){
	nombre++;
	int iterador_arch = quedarme_mayor(disco->ar_actual, disco->cant_archivos);
	for(int i = 0; i < iterador_arch; i++){
		if(!strcmp(nombre, disco->archivos[i]))
			return i;
	}
	return -ENOENT;
}

int eliminar_archivo(disco_t* disco, const char *nombre){
	if(existe_archivo(disco, nombre) == FALSE){
		return -ENOENT;
	}
	int indice_archivo = obtener_archivo(disco, nombre);
	strcpy(disco->archivos[indice_archivo], "");
	strcpy(disco->contenidos[indice_archivo], "");
	strcpy(disco->tabla_arch_dir[indice_archivo], "");
	if(disco->cant_archivos == ARCHIVOS){
		disco->ar_actual = indice_archivo;
	}
	disco->cant_archivos--;
	return EXIT_SUCCESS;
}

int agregar_directorio(disco_t* disco, const char *nombre){
	if(disco->cant_directorios >= DIRECTORIOS)
		return -ENOMEM;
	if(disco->dir_actual > disco->cant_directorios && disco->dir_actual >= DIRECTORIOS)
		actualizar_indice_directorios(disco);
	strcpy(disco->directorios[disco->dir_actual], nombre);
	disco->dir_actual++;
	disco->cant_directorios++;
	return EXIT_SUCCESS;
}

int existe_directorio(const disco_t* disco, const char *nombre){
	nombre++;
	int iterador_dir = quedarme_mayor(disco->dir_actual, disco->cant_directorios);
	for(int i = 0; i<= iterador_dir; i++){
		if(!strcmp(nombre, disco->directorios[i]))
			return TRUE;
	}
	return FALSE;
}

int obtener_directorio(const disco_t* disco, const char *nombre){
	nombre++;
	int iterador_dir = quedarme_mayor(disco->dir_actual, disco->cant_directorios);
	for(int i = 0; i < iterador_dir; i++){
		if(!strcmp(nombre, disco->directorios[i]))
			return i;
	}
	return -ENOENT;
}

void eliminar_archivos_de_directorio(disco_t* disco, const char *nombre){
	int iterador_arch = quedarme_mayor(disco->ar_actual, disco->cant_archivos);
	for(int i = 0; i < iterador_arch; i++){
		if(!strcmp(nombre + 1, disco->tabla_arch_dir[i])){
			strcpy(disco->archivos[i], "");
			strcpy(disco->contenidos[i], "");
			strcpy(disco->tabla_arch_dir[i], "");
			disco->cant_archivos--;
		}
	}
}

int eliminar_directorio(disco_t* disco, const char *nombre){
	if(existe_directorio(disco, nombre) == FALSE){
		return -ENOENT;
	}
	int indice_directorio = obtener_directorio(disco, nombre);
	strcpy(disco->directorios[indice_directorio], "");
	if(disco->cant_directorios == DIRECTORIOS){
		disco->dir_actual = indice_directorio;
	}
	disco->cant_directorios--;
	int iterador_arch = quedarme_mayor(disco->ar_actual, disco->cant_archivos);
	for(int i = 0; i < iterador_arch; i++){
		if(!strcmp(nombre + 1, disco->tabla_arch_dir[i]))
			eliminar_archivos_de_directorio(disco, nombre);
	}
	printf("archivos: %d\n", disco->cant_archivos);
	return EXIT_SUCCESS;
}

//--------------------------------Manejo la persistencia -------------------------------------

int guardar_file_system(disco_t* disco){
	FILE* archivo;
    archivo = fopen(disco->nombre, "wt");
    fputs("Directorios:\n", archivo);
	fprintf(archivo, "%d\n", disco->cant_directorios);
	if(disco->cant_directorios > 0){
		int iterador_dir = quedarme_mayor(disco->dir_actual, disco->cant_directorios);
		for(int i = 0; i < iterador_dir; i++){
			fprintf(archivo, "%s\n", disco->directorios[i]);
		}
	}
	fputs("Archivos:\n", archivo);
	fprintf(archivo, "%d\n", disco->cant_archivos);
	if(disco->cant_archivos > 0){
		int iterador_arch = quedarme_mayor(disco->ar_actual, disco->cant_archivos);
		for(int i = 0; i < iterador_arch; i++){
			fprintf(archivo, "%s:", disco->archivos[i]);
			if(strlen(disco->contenidos[i]) > 0){
				char *sin_barra_n = strtok(disco->contenidos[i], "\n");
				fprintf(archivo, "%s:", sin_barra_n);
			} else {
    			fputs(":", archivo);
			}
			fprintf(archivo, "%s\n", disco->tabla_arch_dir[i]);
		}
	}
	fclose(archivo);
    return EXIT_SUCCESS;
}

void agregar_archivo_a_disco(disco_t* disco, char *archivo){
	char separador[2] = ":";
	char *token;
	char *barra_n = "\n";
	size_t arch_lengt = strlen(archivo);
    token = strtok(archivo, separador);
	int contador = 0;
	size_t ult_lengt = strlen(token);
   	while( contador < 3) {
		if(contador == 0){
			strcpy(disco->archivos[disco->ar_actual], token);
			token = strtok(NULL, separador);
		}
		if(contador == 1){
			if(ult_lengt + strlen(token) + 2 == arch_lengt){
				token = strtok(token, barra_n);
				strcpy(disco->contenidos[disco->ar_actual], "");
				strcpy(disco->tabla_arch_dir[disco->ar_actual], token);
				break;
			} else {
				strcpy(disco->contenidos[disco->ar_actual], token);
				token = strtok(NULL, barra_n);
			}
		}
		if(contador == 2){

			strcpy(disco->tabla_arch_dir[disco->ar_actual], token);
		}
		contador++;
  	}
	disco->ar_actual++;
	disco->cant_archivos++;
}

void crear_archivo(disco_t* disco){
	FILE* archivo;
    archivo = fopen(disco->nombre, "wt");
	fputs("Directorios:\n", archivo);
	fputs("0\n", archivo);
    fputs("Archivos:\n", archivo);
    fputs("0\n", archivo);
	fclose(archivo);
}


void abrir_file_system(disco_t* disco){
	FILE* archivo;
    archivo = fopen(disco->nombre, "rt");
	if(!archivo){
		crear_archivo(disco);
		return;
	}
	char directorio[TAM_NOMBRE_DIR];
	if(!fscanf(archivo, "%s", directorio))
		return;
	int cant_directorios;
	if(!fscanf(archivo, "%d", &cant_directorios))
		return;
	for(int i = 0; i < cant_directorios; i++){
		char nombre_directorio[TAM_NOMBRE_DIR];
		if(!fscanf(archivo, "%s", nombre_directorio))
			return;
		agregar_directorio(disco, nombre_directorio);
	}
	char arch[TAM_NOMBRE_ARCH];
	if(!fscanf(archivo, "%s", arch))
		return;
	int cant_archivos;
	if(!fscanf(archivo, "%d", &cant_archivos))
		return;
	char basura[TAM_NOMBRE_ARCH];
	if(!fgets(basura, TAM_NOMBRE_ARCH, archivo))
		return;

	for(int j = 0; j < cant_archivos; j++){
		char linea_archivo[TAM_ARCH_PERSISTENCIA] = "";
		if(!fgets(linea_archivo, TAM_ARCH_PERSISTENCIA, archivo))
			return;
		agregar_archivo_a_disco(disco, linea_archivo);
	}
	fclose(archivo);
}