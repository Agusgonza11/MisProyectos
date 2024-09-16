#define _POSIX_C_SOURCE 200809L
#include "heap.h"
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdbool.h>
#define FACTOR_REDIMENSIONAR 2

const size_t CAPACIDAD_INICIAL = 20;

struct heap{
	void** arr;
	size_t capacidad;
	size_t cantidad;
	cmp_func_t cmp;
};

heap_t* heap_crear(cmp_func_t cmp){
	heap_t* heap = malloc(sizeof(heap_t));
	if (!heap) return NULL;

	heap->arr = calloc(CAPACIDAD_INICIAL, sizeof(void*));
	if (!heap->arr){
		free(heap);
		return NULL;
	}

	heap->cantidad = 0;
	heap->capacidad = CAPACIDAD_INICIAL;
	heap->cmp = cmp;
	return heap;
}

void swap(void* *x, void* *y) {
	void* aux = *x;
	*x = *y;
	*y = aux;
}


size_t maximo(void* arr[], cmp_func_t cmp, size_t a, size_t b){
	return cmp(arr[a], arr[b]) > 0 ? a : b;	
}

void downheap(void* arr[], size_t tam, size_t padre, cmp_func_t cmp){
	if (padre == tam) return;

	size_t h_izq = 2 * padre + 1;
	size_t h_der = 2 * padre + 2;

	size_t max = padre;

	if (h_izq >= tam && h_der < tam) max = maximo(arr, cmp, padre, h_der);
	else if (h_der >= tam && h_izq < tam) max = maximo(arr, cmp, padre, h_izq);
	else if (h_der < tam && h_izq < tam) max = maximo(arr, cmp, padre, maximo(arr, cmp, h_izq, h_der));

	if (max != padre){
		swap(&arr[padre], &arr[max]);
		downheap(arr, tam, max, cmp);
	}
}

void heapify(void* arr[], size_t n, cmp_func_t cmp){
	for(int i = (int) n / 2 - 1; i >= 0 ; i--){
		downheap(arr, n,(size_t) i, cmp);
	}
}

size_t heap_cantidad(const heap_t* heap){
	return heap->cantidad;
}

bool heap_esta_vacio(const heap_t* heap){
	return heap->cantidad == 0;
}

void heap_destruir(heap_t* heap, void destruir_elemento(void *e)){
	for (int i = 0; i < heap->cantidad && destruir_elemento; i++){
		destruir_elemento(heap->arr[i]);
	}
	free(heap->arr);
	free(heap);
}

void** copiar_arr(void* arr[], size_t n){
	void** dest = calloc(n * 2, sizeof(void*));
	if (!dest) return NULL;

	for (int i = 0; i < n; i++){
		dest[i] = arr[i];
	}
	return dest;
}

void upheap(void* arr[], size_t hijo, cmp_func_t cmp){
	if (hijo <= 0) return;
	size_t padre = (hijo - 1) / 2;
	if (maximo(arr, cmp, padre, hijo) != padre){
		swap(&arr[hijo], &arr[padre]);
		upheap(arr, padre, cmp);
	}
}

heap_t* heap_crear_arr(void* arreglo[], size_t n, cmp_func_t cmp){
	heap_t* heap = malloc(sizeof(heap_t));
	if (!heap) return NULL;

	heap->arr = copiar_arr(arreglo, n);

	if (!heap->arr){
		free(heap);
		return NULL;
	}
	heap->cmp = cmp;
	heap->capacidad = n * 2;
	heap->cantidad = n;


	//convierto el arreglo en un heap
	heapify(heap->arr, heap->cantidad, heap->cmp);


	return heap;
}

//Redimensiona la capacidad del arreglo del heap
//Pre: El heap fue creado
//Post: La nueva capacidad del heap es la pasada por parametro y en ese caso devuelve true, de ocurrir algun fallo devuelve false
bool heap_redimensionar(heap_t* heap, size_t nuevo_largo){
	void *aux = realloc(heap->arr, (heap->capacidad * sizeof(void*) * nuevo_largo));
	if(aux == NULL){
		free(aux);
		return false;
	}
	heap->capacidad = nuevo_largo;  
	heap->arr = aux;
	return true;
}


bool heap_encolar(heap_t *heap, void *elem){
	if(heap->cantidad==heap->capacidad){
		if(!heap_redimensionar(heap, heap->capacidad * FACTOR_REDIMENSIONAR)){
			return false;
		}
	}
	heap->arr[heap->cantidad] = elem;
	upheap(heap->arr, heap->cantidad, heap->cmp);
	heap->cantidad++;
	return true;
}

void *heap_ver_max(const heap_t *heap){
	if(heap_esta_vacio(heap)) return NULL;
	return heap->arr[0];
}
	
void *heap_desencolar(heap_t *heap){
	if(heap_esta_vacio(heap)) return NULL;
	if(heap->capacidad > heap->cantidad * FACTOR_REDIMENSIONAR * 3 && heap->capacidad != CAPACIDAD_INICIAL){
		if(!heap_redimensionar(heap, heap->capacidad / FACTOR_REDIMENSIONAR)){
			return false;
		}
	}
	void* desencolado = heap->arr[0];
	swap(&heap->arr[0], &heap->arr[heap->cantidad-1]);
	heap->cantidad--;
	downheap(heap->arr, heap->cantidad, 0, heap->cmp);
	return desencolado;
}

void heap_sort(void *elementos[], size_t cant, cmp_func_t cmp){
	heapify(elementos, cant, cmp);
	
	for(int i = (int) cant - 1; i >= 0 ; i--){
		swap(&elementos[0], &elementos[i]);
		downheap(elementos, (size_t) i, 0, cmp);
	}
}

