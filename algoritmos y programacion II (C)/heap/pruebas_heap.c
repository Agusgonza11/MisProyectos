#define _POSIX_C_SOURCE 200809L
#include "heap.h"
#include "testing.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int comparar_enteros(const void* clave_1,const void* clave_2){
	int c1 = atoi((char*) clave_1);
	int c2 = atoi((char*) clave_2);

	if (c1 == c2) return 0;
	return c2 < c1 ? 1 : -1;
}

static void prueba_heap_crear_vacio(){
	heap_t* heap = heap_crear(comparar_enteros);
	print_test("Se pudo crear un heap vacio", heap != NULL);
	print_test("La cantidad de elementos del heap es 0", heap_cantidad(heap) == 0);
	print_test("El heap esta vacio", heap_esta_vacio(heap));
	print_test("Si intento ver el maximo recibo NULL", heap_ver_max(heap) == NULL);
	print_test("Si intento desencolar recibo NULL", heap_desencolar(heap) == NULL);
	heap_destruir(heap, NULL);
}

static void prueba_heap_crear_cor_arr(){
	char* arreglo[10];

	for (int i = 0; i < 10; i++){
		arreglo[i] = malloc(2 * sizeof(char));
		sprintf(arreglo[i], "%d", i);
	}

	void** arr = (void**) arreglo;

	heap_t* heap = heap_crear_arr(arr, 10, comparar_enteros);
	print_test("Se pudo crear un heap a partir de un arreglo del 0 al 9", heap != NULL);
	print_test("La cantidad de elementos es 10", heap_cantidad(heap) == 10);
	print_test("El heap no esta vacio", !heap_esta_vacio(heap));
	print_test("El elemento de maxima prioridad del heap es 9", strcmp(heap_ver_max(heap), "9") == 0);
	print_test("Si desencolo recibo 9", strcmp(heap_desencolar(heap), "9") == 0);
	print_test("La cantidad de elementos es 9", heap_cantidad(heap) == 9);

	bool desencolar = true;
	bool cantidad = true;
	bool prioridad = true;

	for (int j = 0; j < 9; j++){
		cantidad &= heap_cantidad(heap) == 9 - j;
		prioridad &= heap_ver_max(heap) == arreglo[9 - j - 1];
		desencolar &= heap_desencolar(heap) == arreglo[9 - j - 1];
	}

	print_test("Desencolando todos los elementos la cantidad fue correcta siempre", cantidad);
	print_test("El de maxima prioridad siempre fue correcto", prioridad);
	print_test("Al desencolar recibi el elemento correcto siempre", desencolar);

	for (int k = 0; k < 10; k++){
		free(arreglo[k]);
	}

	heap_destruir(heap, NULL);
}

static void prueba_heap_encolar(){
	heap_t* heap = heap_crear(comparar_enteros);

	char* A = "1";
	char* B = "2"; 
	char* C = "3";

	print_test("Se pudo encolar A", heap_encolar(heap, A));
	print_test("Ahora la cantidad de elementos es 1", heap_cantidad(heap) == 1);
	print_test("Ahora el heap no esta vacio", !heap_esta_vacio(heap));
	print_test("Al ver el elemento de maxima prioridad recibo A", strcmp(heap_ver_max(heap), A) == 0);
	print_test("Al desencolar recibo A", strcmp(heap_desencolar(heap), A) == 0);
	print_test("Ahora el heap esta vacio", heap_esta_vacio(heap));
	print_test("Ahora la cantidad de elementos es 0", heap_cantidad(heap) == 0);
	print_test("Se pudo guardar B", heap_encolar(heap, B));
	print_test("Ahora la cantidad de elementos es 1", heap_cantidad(heap) == 1);
	print_test("Ahora el heap no esta vacio", !heap_esta_vacio(heap));
	print_test("Se pudo encolar A", heap_encolar(heap, A));
	print_test("Ahora la cantidad de elementos es 2", heap_cantidad(heap) == 2);
	print_test("Se pudo encolar C", heap_encolar(heap, C));
	print_test("Ahora la cantidad de elementos es 3", heap_cantidad(heap) == 3);
	print_test("Si veo el de mayor prioridad es C", strcmp(heap_ver_max(heap), C) == 0);
	print_test("Si desencolo recibo C", strcmp(heap_desencolar(heap), C) == 0);
	print_test("Ahora la cantidad de elementos es 2", heap_cantidad(heap) == 2);
	print_test("El heap no esta vacio", !heap_esta_vacio(heap));
	print_test("Si veo el maximo recibo B", strcmp(heap_ver_max(heap), B) == 0);

	heap_destruir(heap, NULL);
}

static void prueba_heap_encolar_NULL(){
	heap_t* heap = heap_crear(comparar_enteros);

	char* A = NULL;

	print_test("Se pudo encolar NULL", heap_encolar(heap, A));
	print_test("La cantidad de elementos es 1", heap_cantidad(heap) == 1);
	print_test("El heap no esta vacio", !heap_esta_vacio(heap));
	print_test("Si busco el elemento de maxima prioridad es NULL", heap_ver_max(heap) == NULL);
	print_test("Si desencolo recibo NULL", heap_desencolar(heap) == NULL);
	print_test("Ahora la cantidad de elementos es 0", heap_cantidad(heap) == 0);
	print_test("Ahora el heap esta vacio", heap_esta_vacio(heap));
	heap_destruir(heap, NULL);
}


static void prueba_destruir_vacio_sin_funcion(){
	//Destruyo uno vacio sin funcion para destruir elementos
	heap_t* heap = heap_crear(comparar_enteros);
	heap_destruir(heap, NULL);
	print_test("Se destruyo un heap vacio", true);
}

static void prueba_destruir_no_vacio_sin_funcion(){
	//Destruyo uno con elementos pero sin funcion para destruir elementos
	char* A = "1";
	char* B = "2";
	char* C = "3";
	heap_t* heap = heap_crear(comparar_enteros);
	
	print_test("Se pudo encolar A", heap_encolar(heap, A));
	print_test("Se pudo encolar B", heap_encolar(heap, B));
	print_test("Se pudo encolar C", heap_encolar(heap, C));

	heap_destruir(heap, NULL);
	print_test("Se destruyo un heap con elementos pero sin funcion para destruirlos", true);
}

static void prueba_destruir_vacio_con_funcion(){
	//Destruyo uno sin elementos pero con funcion para destruir los elementos
	heap_t* heap = heap_crear(comparar_enteros);
	heap_destruir(heap, free);
	print_test("Se destruyo un heap sin elementos pero con funcion para destruirlos", true);
}

static void prueba_destruir_no_vacio_con_funcion(){
	//Destruyo uno con elementos y con funcion para destruirlos.
	//Uso memoria dinamica => le paso "free()" como funcion
	//de destruccion de datos.

	bool encolar = true;

	char* arreglo[10];

	for (int i = 0; i < 10; i++){
		arreglo[i] = malloc(2 * sizeof(char));
		sprintf(arreglo[i], "%d", i);
	}

	heap_t* heap = heap_crear(comparar_enteros);

	for (int j = 0; j < 10; j++){
		encolar &= heap_encolar(heap, arreglo[j]);
	}

	print_test("Se pudieron encolar 10 elementos", encolar);
	heap_destruir(heap, free);
	print_test("Se destruyo un heap con elementos y con funcion para destruirlos", true);
}

static void prueba_volumen(){
	char* arreglo[1000];

	for (int i = 0; i < 1000; i++){
		arreglo[i] = malloc(4 * sizeof(char));
		sprintf(arreglo[i], "%d", i);
	}

	heap_t* heap = heap_crear(comparar_enteros);

	bool encolar = true;
	bool cantidad = true;
	bool maximo = true;

	for (int j = 0; j < 1000; j++){
		encolar &= heap_encolar(heap, arreglo[j]);
		cantidad &= heap_cantidad(heap) == j + 1;
		maximo &= heap_ver_max(heap) == arreglo[j];
	}

	print_test("Se pudieron encolar 1000 elementos", encolar);
	print_test("La cantidad de elementos siempre fue correcta", cantidad);
	print_test("El elemento de maxima prioridad siempre fue correcto", maximo);

	bool desencolar = true;
	cantidad = true;
	maximo = true;

	for (int k = 0; k < 1000; k++){
		cantidad &= heap_cantidad(heap) == 1000 - k;
		maximo &= heap_ver_max(heap) == arreglo[1000 - k - 1];
		desencolar &= heap_desencolar(heap) == arreglo[1000 - k - 1];
	}

	print_test("Al desencolar la cantidad siempre fue correcta", cantidad);
	print_test("El maximo siempre fue correcto", maximo);
	print_test("Desencolar devolvio siempre el elemento correcto", desencolar);

	for (int l = 0; l < 1000; l++){
		free(arreglo[l]);
	}

	heap_destruir(heap, NULL);
}


static void prueba_heapsort(){
	int arr[10];

	arr[0] = 4;
	arr[1] = 7;
	arr[2] = 6;
	arr[3] = 2;
	arr[4] = 1;
	arr[5] = 3;
	arr[6] = 5;
	arr[7] = 9;
	arr[8] = 8;
	arr[9] = 0;

	void* arreglo[10];

	for (int i = 0; i < 10; i++){
		arreglo[i] = malloc(2 * sizeof(char));
		sprintf(arreglo[i], "%d", arr[i]);
	}

	heap_sort(arreglo, 10, comparar_enteros);

	char str[2] = "";

	bool ordenado = true;

	for (int j = 0; j < 10; j++){
		sprintf(str, "%d", j);
		ordenado &= strcmp(arreglo[j], str) == 0;
	}
	print_test("Heap_sort ordena bien", ordenado);

	for (int k = 0; k < 10; k++){
		free(arreglo[k]);
	}

}

void pruebas_heap_estudiante(void){
	prueba_heap_crear_vacio();
	prueba_heap_crear_cor_arr();
	prueba_heap_encolar();
	prueba_heap_encolar_NULL();
	prueba_destruir_vacio_sin_funcion();
	prueba_destruir_no_vacio_sin_funcion();
	prueba_destruir_vacio_con_funcion();
	prueba_destruir_no_vacio_con_funcion();
	prueba_volumen();
	prueba_heapsort();
}

#ifndef CORRECTOR  // Para que no dé conflicto con el main() del corrector.

int main(void) {
	pruebas_heap_estudiante();
	return failure_count() > 0;  // Indica si falló alguna prueba.
}

#endif
