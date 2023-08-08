#include "lista.h"
#include <stdlib.h>

typedef struct nodo {
	void *dato;
	struct nodo *sig;
} nodo_t;

struct lista {
	nodo_t *prim;
	nodo_t *ult;
	size_t largo;
};
 
nodo_t* nodo_crear(void* valor){
	nodo_t* nodo = malloc(sizeof(nodo_t));
	if(!nodo) return NULL;
	nodo->dato = valor;
	nodo->sig = NULL;
	return nodo;
}

lista_t* lista_crear(void){
	lista_t *lista = malloc(sizeof(lista_t));
	if(!lista) return NULL;
	lista->prim = NULL;
	lista->ult = NULL;
	lista->largo = 0;
	return lista;
}

bool lista_esta_vacia(const lista_t *lista){
	if(lista->prim==NULL){
		return true;
	}
	return false;
}

bool lista_insertar_primero(lista_t *lista, void *dato){
	nodo_t* nuevo_nodo = nodo_crear(dato);
	if(!nuevo_nodo) return false;
	if(lista->prim==NULL){
		lista->prim = nuevo_nodo;
		lista->ult = nuevo_nodo;
	}
	else{
		nuevo_nodo->sig = lista->prim;
		lista->prim = nuevo_nodo;	
	}
	lista->largo++;
	return true;
}


bool lista_insertar_ultimo(lista_t *lista, void *dato){
	nodo_t* nuevo_nodo = nodo_crear(dato);
	if(!nuevo_nodo) return false;
	if(lista->prim==NULL){
		lista->prim = nuevo_nodo;
		lista->ult = nuevo_nodo;
	}
	else{
		lista->ult->sig = nuevo_nodo;
		lista->ult = nuevo_nodo;	
	}
	lista->largo++;
	return true;
}

void *lista_borrar_primero(lista_t *lista){
	if(lista_esta_vacia(lista)){
		return NULL;
	}
	nodo_t* nodo_borrar = lista->prim;
	void* dato = nodo_borrar->dato;
	if(lista->prim==lista->ult){
		lista->prim = NULL;
		lista->ult = NULL;
	}	
	else{
		lista->prim = lista->prim->sig;
	}
	free(nodo_borrar);
	lista->largo--;
	return dato;
}


void *lista_ver_primero(const lista_t *lista){
	if(lista_esta_vacia(lista)){
		return NULL;
	}
	return lista->prim->dato;
}


void *lista_ver_ultimo(const lista_t* lista){
	if(lista_esta_vacia(lista)){
		return NULL;
	}
	return lista->ult->dato;
}

size_t lista_largo(const lista_t *lista){
	if(lista_esta_vacia(lista)){
		return 0;
	}
	return lista->largo;
}

void lista_destruir(lista_t *lista, void (*destruir_dato)(void *)){
	nodo_t* actual = lista->prim;
	while(actual){
		nodo_t* siguiente = actual->sig;
		if(destruir_dato !=NULL){
			destruir_dato(actual->dato);
		}
		free(actual);
		actual = siguiente;
	}
	free(lista);
}

void lista_iterar(lista_t *lista, bool visitar(void *dato, void *extra), void *extra){
	nodo_t* actual = lista->prim;
	while(actual && visitar(actual->dato, extra)){
		actual = actual->sig;
	}
}



struct lista_iter{
	nodo_t *actual;
	nodo_t *anterior;
	lista_t* lista_guardar;
};


lista_iter_t* lista_iter_crear(lista_t *lista){
	lista_iter_t *iter = malloc(sizeof(lista_iter_t));
	if(!iter) return NULL;
	iter->lista_guardar = lista;
	iter->actual = lista->prim;
	iter->anterior = NULL;
	return iter;
}

bool lista_iter_avanzar(lista_iter_t *iter){
	if(iter->actual==NULL){
		return false;
	}
	iter->anterior = iter->actual;
	iter->actual = iter->actual->sig;
	return true;
}

bool lista_iter_al_final(const lista_iter_t *iter){
	if(iter->actual==NULL){
		return true;
	}
	return false;
}

void *lista_iter_ver_actual(const lista_iter_t *iter){
	if(lista_iter_al_final(iter)){
		return NULL;
	}
	void* dato = iter->actual->dato;
	return dato;
}


void lista_iter_destruir(lista_iter_t *iter){
	free(iter);
}


bool lista_iter_insertar(lista_iter_t *iter, void *dato){
	nodo_t* nuevo_nodo = nodo_crear(dato);
	if(!nuevo_nodo) return false;
	if(lista_iter_al_final(iter) && iter->anterior!=NULL){
		iter->anterior->sig = nuevo_nodo;
		iter->lista_guardar->ult = nuevo_nodo;
		nuevo_nodo->sig = NULL;
	}
	if(iter->lista_guardar->prim != NULL && iter->anterior!=NULL){
		iter->anterior->sig = nuevo_nodo;
		nuevo_nodo->sig = iter->actual;
	}
	if(iter->lista_guardar->prim == iter->actual && iter->lista_guardar->prim != NULL){
		iter->lista_guardar->prim = nuevo_nodo;
		nuevo_nodo->sig = iter->actual;
	}
	if(iter->lista_guardar->prim == NULL){
		iter->lista_guardar->prim = nuevo_nodo;
		iter->lista_guardar->ult = nuevo_nodo;	
	}
	iter->actual = nuevo_nodo;
	iter->lista_guardar->largo++;
	return true;
}


void *lista_iter_borrar(lista_iter_t *iter){
	if(lista_iter_al_final(iter)){
		return NULL;
	}
	void* dato = iter->actual->dato;
	nodo_t* nodo_borrar = iter->actual;
	if(iter->lista_guardar->prim == iter->lista_guardar->ult){
		iter->lista_guardar->prim = NULL;
		iter->lista_guardar->ult = NULL;
		iter->actual = NULL;
		
	}
	if(iter->anterior==NULL && iter->lista_guardar->largo > 1){
		nodo_t* siguiente = iter->actual->sig;
		iter->actual = siguiente;
		iter->lista_guardar->prim = iter->actual;				
	}
	if(iter->anterior!=NULL){
		iter->anterior->sig = iter->actual->sig;
		if(iter->lista_guardar->ult == iter->actual){
			iter->lista_guardar->ult = iter->anterior;
		}
		iter->actual = iter->anterior->sig;
	}
	free(nodo_borrar);
	iter->lista_guardar->largo--;
	return dato;		
}



