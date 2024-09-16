#define _POSIX_C_SOURCE 200809L
#include "procesar_usuarios.h"
#include "lista.h"
#include "hash.h"
#include "strutil.h"
#include <stdbool.h>
#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>




typedef	struct usuario{
	char* nombre;	//El nombre del usuario
	char* nombre15; //El nombre del usuario pero con 15 caracteres, sera usado para ordenar
	hash_t* tweets; //Diccionario con todos los tweets
	size_t cantidad;//Cantidad de tweets escritos por el usuario
}usuario_t;

typedef struct counting{ //Estructura creada para facilitar el algoritmo de counting sort
	hash_t* sumas_acum;  //Arreglo de sumas acumuladas
	hash_t* posiciones;  //Arreglo de posiciones
}counting_t;

counting_t* crear_count(){
	counting_t* count = malloc(sizeof(counting_t));
	if(!count) return NULL;
	hash_t* sumas_acum = hash_crear(NULL);
	hash_t* posiciones = hash_crear(NULL);
	if(!sumas_acum || !posiciones){
		hash_destruir(sumas_acum);
		hash_destruir(posiciones);
		return NULL;
	}
	char* letras = "abcdefghijkmnlopqrstuvwxyz";
	for(size_t i = 0 ; i < 24 ; i++){
		char guardar[] = {letras[i],'\0'};
		hash_guardar(sumas_acum, guardar,(void*) 0);
		hash_guardar(posiciones, guardar,(void*) 0);
	}
	count->sumas_acum = sumas_acum;
	count->posiciones = posiciones;
	return count;
}

void llenar_count(counting_t* count, hash_t* usuarios, lista_t* lista, int pos){
	lista_iter_t* iter_listas = lista_iter_crear(lista);
	while(!lista_iter_al_final(iter_listas)){
		char* nombre = (char*) lista_iter_ver_actual(iter_listas);
		usuario_t* usuario = hash_obtener(usuarios, nombre);
		char* ordenar = usuario->nombre15;
		char letra[] = {ordenar[pos],'\0'};
		size_t cant = (size_t) hash_obtener(count->sumas_acum, letra);
		hash_guardar(count->sumas_acum, letra,(void*) cant+1);	
		lista_iter_avanzar(iter_listas);
	}
	lista_iter_destruir(iter_listas);
	size_t suma = 0;
	char* letras = "abcdefghijkmnlopqrstuvwxyz";
	for(size_t i = 0 ; i < 26 ; i++){
		char guardar[] = {letras[i],'\0'};
		hash_guardar(count->posiciones, guardar,(void*) suma);
		size_t cantidad = (size_t) hash_obtener(count->sumas_acum, guardar);
		size_t posicion = (size_t) hash_obtener(count->posiciones, guardar);	
		suma = cantidad + posicion;	
	}	
}

void destruir_count(counting_t* count){
	hash_destruir(count->sumas_acum);
	hash_destruir(count->posiciones);
	free(count);	
}


usuario_t* crear_usuario(char* nombre){
	usuario_t* usuario = malloc(sizeof(usuario_t));
	if(!usuario) return NULL;
	usuario->nombre = nombre;
	usuario->tweets = hash_crear(NULL);
	usuario->cantidad = 0;
	size_t largo = strlen(nombre);
	char* cadena = calloc(15, sizeof(char));
	if(!cadena){
		free(usuario);
		return NULL;
	}
	if(largo<15){
		char* z = "zzzzzzzzzzzzzzz";
		strncpy(cadena, nombre, largo);	
		strncpy(cadena + largo, z, 15 - largo);
	} else {
		strncpy(cadena, nombre, 15); 
	}
	usuario->nombre15 = cadena;
	return usuario;
}

void destruir_usuario(usuario_t* usuario){
	hash_destruir(usuario->tweets);
	free(usuario->nombre15);
	free(usuario);
}


void agregar_usuario(char* linea, hash_t* usuarios){
	char** strv = split(linea, ',');
	char* nombre = 	strv[0];
	usuario_t* usuario;
	if(!hash_pertenece(usuarios, nombre)){
		usuario = crear_usuario(strv[0]);
		hash_guardar(usuarios, nombre, usuario);
	} else {
		usuario = hash_obtener(usuarios, nombre);
	}
	for(size_t i = 1; strv[i]!=NULL ; i++){
		if(!hash_pertenece(usuario->tweets, strv[i])){
			hash_guardar(usuario->tweets, strv[i], NULL);
			usuario->cantidad += 1;
		} 
	}
	free_strv(strv);
}

void destruir_usuarios(hash_t* usuarios){
	hash_iter_t* iter = hash_iter_crear(usuarios);
	while(!hash_iter_al_final(iter)){
		char* nombre = (char*) hash_iter_ver_actual(iter);
		usuario_t* usuario = hash_obtener(usuarios, nombre);
		destruir_usuario(usuario);
		hash_iter_avanzar(iter);
	}
	hash_iter_destruir(iter);
}



void calcular_rango(hash_t* usuarios, size_t *min, size_t *max){
	hash_iter_t* iter = hash_iter_crear(usuarios);
	if(!iter) return;
	char* primero = (char*) hash_iter_ver_actual(iter);
	usuario_t* primer_usuario = hash_obtener(usuarios, primero);
	size_t maximo = primer_usuario->cantidad;
	size_t minimo = primer_usuario->cantidad;
	hash_iter_avanzar(iter);
	while(!hash_iter_al_final(iter)){
		char* nombre = (char*) hash_iter_ver_actual(iter);
		usuario_t* usuario = hash_obtener(usuarios, nombre);
		if(usuario->cantidad > maximo) maximo = usuario->cantidad;
		if(usuario->cantidad < minimo) minimo = usuario->cantidad;
		hash_iter_avanzar(iter);
	}
	hash_iter_destruir(iter);
	*min = minimo;
	*max = maximo;
}

hash_t* llenar_baldes(hash_t* usuarios, size_t min, size_t max){
	hash_t* baldes = hash_crear(NULL);
	if(!baldes) return NULL;
	for(size_t i = min; i<= max ; i++){
		lista_t* lista = lista_crear();
		char num[] = {(char)i,'\0'};
		hash_guardar(baldes, num, lista);
	}
	hash_iter_t* iter = hash_iter_crear(usuarios);
	while(!hash_iter_al_final(iter)){
		char* nombre = (char*) hash_iter_ver_actual(iter);
		usuario_t* usuario = hash_obtener(usuarios, nombre);
		char num[] = {(char)usuario->cantidad,'\0'};
		lista_t* lista = hash_obtener(baldes, num);
		lista_insertar_ultimo(lista, nombre);
		hash_iter_avanzar(iter);
	}
	hash_iter_destruir(iter);
	return baldes;
}

void ordenar_letra(hash_t* usuarios, lista_t* lista, int pos){
	counting_t* count = crear_count();
	llenar_count(count, usuarios, lista, pos);
	
	char** lista_aux = calloc(lista_largo(lista), sizeof(char*));
	if(!lista_aux) return;
	lista_iter_t* iter = lista_iter_crear(lista);
	while(!lista_iter_al_final(iter)){
		char* nombre = (char*) lista_iter_ver_actual(iter);
		usuario_t* usuario = hash_obtener(usuarios, nombre);
		char* ordenar = usuario->nombre15;
		char letra[] = {ordenar[pos],'\0'};
		size_t posicion = (size_t) hash_obtener(count->posiciones, letra);
		hash_guardar(count->posiciones, letra, (void*) posicion + 1);
		lista_aux[posicion] = nombre;
		lista_iter_avanzar(iter);
	}
	lista_iter_destruir(iter);
	for(size_t i = 0; i < lista_largo(lista) ; i++){
		lista_borrar_primero(lista);
		lista_insertar_ultimo(lista, lista_aux[i]);
	}	
	free(lista_aux);
	destruir_count(count);
}


void ordenar_lista(hash_t* usuarios, lista_t* lista){
	for(int i = 14; i>=0 ; i--){
		ordenar_letra(usuarios, lista, i);
	}
}


void ordenar_baldes(hash_t* baldes, hash_t* usuarios){
	hash_iter_t* iter = hash_iter_crear(baldes);
	while(!hash_iter_al_final(iter)){
		size_t numero = (size_t) hash_iter_ver_actual(iter);
		lista_t* lista = hash_obtener(baldes,(char*) numero);
		if(lista_largo(lista) > 1){
			ordenar_lista(usuarios, lista);
		} 
		hash_iter_avanzar(iter);
	}
	hash_iter_destruir(iter);
}


void imprimir_baldes(hash_t* baldes, size_t min, size_t max, hash_t* usuarios){
	for(size_t i = min; i <= max ; i++){	
		char num[] = {(char)i,'\0'};		
		lista_t* lista = hash_obtener(baldes, num);
		if(lista_esta_vacia(lista)){
			lista_destruir(lista, NULL);
			continue;
		}
		printf("%ld: ", i);
		lista_iter_t* iter = lista_iter_crear(lista);
		while(!lista_iter_al_final(iter)){
			char* nombre = (char*) lista_iter_ver_actual(iter);
			printf("%s ", nombre);
			lista_iter_avanzar(iter);
		}
		lista_iter_destruir(iter);
		lista_destruir(lista, NULL);
		printf("\n");
	}
}


void imprimir_usuarios(hash_t* usuarios){
	size_t min;
	size_t max;
	calcular_rango(usuarios, &min, &max);
	hash_t* baldes = llenar_baldes(usuarios, min, max);
	ordenar_baldes(baldes, usuarios);
	imprimir_baldes(baldes, min, max, usuarios);
	hash_destruir(baldes);
}


void procesar_usuarios(char* nombre_archivo){
	FILE *archivo = fopen(nombre_archivo, "r");
	if(archivo==NULL) return;
	int tam = 500;
	char linea[tam];
	hash_t* usuarios = hash_crear(NULL);
	if(!usuarios) return;
	while((fgets(linea, tam, archivo)) != NULL){
		agregar_usuario(linea, usuarios);
	}
	imprimir_usuarios(usuarios);
	destruir_usuarios(usuarios);
	hash_destruir(usuarios);
	fclose(archivo);
}


int main(int argc, char* argv[]){
	if(argc<1) return -1;
	procesar_usuarios(argv[1]);
	return 0;
}














