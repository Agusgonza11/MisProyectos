#include "pila.h"
#include <stdlib.h>
#include <stdio.h>

/* Definición del struct pila proporcionado por la cátedra.
 */
struct pila {
    void **datos;
    size_t cantidad;   // Cantidad de elementos almacenados.
    size_t capacidad;  // Capacidad del arreglo 'datos'.
};

#define AUMENTAR 1
#define REDUCIR 0
#define FACTOR_MUL 2
#define CAPACIDAD 5


bool redimensionar_memoria_pila(pila_t *pila, int instruccion){
	//recibe la pila y un numero que sirve como instruccion, si es 1 aumenta la memoria
	//y si es 0 la reduce
	if(instruccion==AUMENTAR){
		void *aux = realloc(pila->datos, (pila->capacidad * sizeof(void*)) * FACTOR_MUL);
		if(aux == NULL){
			free(aux);
			return false;
		}
		pila->capacidad = pila->capacidad*FACTOR_MUL;	
		pila->datos = aux;
	}
	if(instruccion==REDUCIR){
		void *aux = realloc(pila->datos, (pila->capacidad * sizeof(void*))/FACTOR_MUL);
		if(aux == NULL){
			free(aux);
			return false;
		}
		pila->capacidad = pila->capacidad / FACTOR_MUL;
		pila->datos = aux;
	}
	return true;
}	

void pila_destruir(pila_t *pila){
	free(pila->datos);
	free(pila);
}


bool pila_esta_vacia(const pila_t *pila){
	if(pila->cantidad == 0){
		return true;
	}
	return false;
}


bool pila_apilar(pila_t *pila, void *valor){
	if(pila->cantidad==pila->capacidad){
		if(!redimensionar_memoria_pila(pila, AUMENTAR)){
			printf("Fallo el redimensionamiento de la pila\n");
			return false;
		}
	}
	pila->datos[pila->cantidad] = valor; 
	pila->cantidad++;
	return true;
}


void *pila_ver_tope(const pila_t *pila){
	if(pila_esta_vacia(pila)){
		return NULL;
	}
	return pila->datos[pila->cantidad-1];
}


void *pila_desapilar(pila_t *pila){
	if(pila_esta_vacia(pila)){
		return NULL;
	}
	if(pila->cantidad*4 <= pila->capacidad && pila->cantidad > 1){
		if(!redimensionar_memoria_pila(pila, REDUCIR)){
			printf("Fallo el redimensionamiento de la pila\n");
		}
	}
	pila->cantidad--;
	return pila->datos[pila->cantidad];
}



pila_t *pila_crear(void) {
    pila_t *pila = malloc(sizeof(pila_t));
    pila->cantidad = 0;
    if (pila == NULL) {
        return NULL;
    }
    pila->capacidad = CAPACIDAD;
    pila->datos = malloc(pila->capacidad * sizeof(void*));

    if (pila->cantidad > 0 && pila->datos == NULL) {
        free(pila);
        return NULL;
    }
    return pila;
}

