#include "cola.h"
#include <stdlib.h>

typedef struct nodo {
	void *dato;
	struct nodo *sig;
} nodo_t;

struct cola {
	nodo_t *prim;
	nodo_t *ult;
};
 
 
nodo_t* nodo_crear(void* valor){
	nodo_t* nodo = malloc(sizeof(nodo_t));
	if(!nodo) return NULL;
	nodo->dato = valor;
	nodo->sig = NULL;
	return nodo;
}

cola_t *cola_crear(void){
	cola_t *cola = malloc(sizeof(cola_t));
	cola->prim = NULL;
	cola->ult = NULL;
	return cola;
}

bool cola_esta_vacia(const cola_t *cola){
	return cola->prim == NULL;
}


bool cola_encolar(cola_t *cola, void *valor){
	nodo_t* nuevo_nodo = nodo_crear(valor);
	if(!nuevo_nodo) return false;
	if(cola->prim==NULL){
		cola->prim = nuevo_nodo;
		cola->ult = nuevo_nodo;
	} else{
		cola->ult->sig = nuevo_nodo;
		cola->ult = cola->ult->sig;	
	}
	return true;
}

void *cola_ver_primero(const cola_t *cola){
	if(cola_esta_vacia(cola)){
		return NULL;
	}
	return cola->prim->dato;
}

void *cola_desencolar(cola_t *cola){
	if(cola_esta_vacia(cola)){
		return NULL;
	}
	nodo_t* nodo_desencolado = cola->prim;
	void* dato = nodo_desencolado->dato;
	if(cola->prim==cola->ult){
		cola->prim = NULL;
		cola->ult = NULL;
		free(nodo_desencolado);
		return dato;
	} 
	cola->prim = cola->prim->sig;
	free(nodo_desencolado);
	return dato;
}


void cola_destruir(cola_t *cola, void (*destruir_dato)(void *)){
	while(!cola_esta_vacia(cola)){
		if(destruir_dato !=NULL){
			destruir_dato(cola_desencolar(cola));
		} else {
		cola_desencolar(cola);
		}
	}
	free(cola);
}




