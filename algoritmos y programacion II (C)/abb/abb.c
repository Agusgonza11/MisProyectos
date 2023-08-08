#define _POSIX_C_SOURCE 200809L
#include "abb.h"
#include "pila.h"
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#define IZQUIERDO -1
#define DERECHO 1

typedef struct nodo {
	struct nodo* izq;
	struct nodo* der;
	char* clave;
	void* dato;
} nodo_t;


struct abb {
	abb_comparar_clave_t cmp;
	abb_destruir_dato_t destruir_dato;
	nodo_t* raiz;
	size_t cant;
};


nodo_t* crear_nodo(const char* clave_ingresada, void* dato_ingresado){
	nodo_t* nodo = malloc(sizeof(nodo_t));
	if(!nodo) return NULL;
	char* clave_c = strdup(clave_ingresada);
	if (!clave_c){
		free(nodo);
		return NULL;
	}
	nodo->clave = clave_c;
	nodo->dato = dato_ingresado;
	nodo->der = NULL;
	nodo->izq = NULL;
	return nodo;
}

void destruir_nodo(nodo_t* nodo){
	free(nodo->clave);
	free(nodo);
}


//Busca el padre de la clave que se pasa por parametro y guarda en el puntero "hijo" si es 
//el hijo izquierdo o el derecho, tambien almacena en el nodo padre al padre de ese nodo buscado
nodo_t* buscar_padre(const abb_t* arbol, nodo_t* raiz, const char* clave, int* hijo, nodo_t** padre){
	if(!raiz){
		return NULL;
	}
	if(arbol->cmp(clave, raiz->clave)==0){
		return raiz;
	}
	if(padre){
		*padre = raiz;
	}
	if(arbol->cmp(clave, raiz->clave)>0){
		if(hijo) *hijo = DERECHO;
		return buscar_padre(arbol, raiz->der, clave, hijo, padre);
	} else{
		if(hijo) *hijo = IZQUIERDO;
		return buscar_padre(arbol, raiz->izq, clave, hijo, padre);
	}
	return NULL;
}


nodo_t* buscar_reemplazante(const abb_t* arbol, nodo_t* reemplazar){
	nodo_t* reemplazante = reemplazar->izq;
	while(reemplazante->der && reemplazante){
		reemplazante = reemplazante->der;
	}
	return reemplazante;
}



abb_t* abb_crear(abb_comparar_clave_t cmp, abb_destruir_dato_t destruir_dato){
	abb_t* abb = malloc(sizeof(abb_t));
	if(!abb) return NULL;
	abb->raiz = NULL;
	abb->cmp = cmp;
	abb->destruir_dato = destruir_dato;
	abb->cant = 0;
	return abb;
}

bool arbol_esta_vacio(const abb_t* arbol){
	return arbol->raiz==NULL;
}


bool abb_guardar(abb_t *arbol, const char *clave, void *dato){
	if(!arbol){
		return false;
	}
	if(arbol_esta_vacio(arbol)){
		nodo_t* nodo = crear_nodo(clave,dato);
		if (!nodo) return false;
		arbol->raiz = nodo;
		arbol->cant++;
		return true;
	}
	int hijo;
	nodo_t* padre;
	nodo_t* buscado = buscar_padre(arbol, arbol->raiz, clave, &hijo, &padre);
	if(buscado){
		if(arbol->destruir_dato) arbol->destruir_dato(buscado->dato);
		buscado->dato = dato;
	} else {
		nodo_t* nodo = crear_nodo(clave,dato);
		if (!nodo) return false;
		if(hijo==IZQUIERDO){
			padre->izq = nodo;
		} else {
			padre->der = nodo;
		}
		arbol->cant++;
	}
	return true;
}


size_t abb_cantidad(const abb_t *arbol){
	if(!arbol) return 0;
	return arbol->cant;
}


void *abb_obtener(const abb_t *arbol, const char *clave){
	if(!arbol) return NULL;
	if(arbol_esta_vacio(arbol)) return NULL;
	nodo_t* buscado = buscar_padre(arbol, arbol->raiz, clave, NULL, NULL);
	if(buscado){
		return buscado->dato;
	} 
	return NULL;
}

bool abb_pertenece(const abb_t *arbol, const char *clave){
	if(!arbol) return false;
	if(arbol_esta_vacio(arbol)) return false;
	nodo_t* buscado = buscar_padre(arbol, arbol->raiz, clave, NULL, NULL);
	if(buscado){
		return true;
	} 
	return NULL;
}
//Funcion auxiliar para el caso de que entre recursivamente a abb_borrar 
void *_abb_borrar(abb_t *arbol, const char *clave){
	void* dato = abb_borrar(arbol, clave);
	arbol->cant++;
	return dato;
}

void *abb_borrar(abb_t *arbol, const char *clave){
	if(!arbol) return NULL;
	if(arbol_esta_vacio(arbol)) return NULL;
	nodo_t* padre;
	int hijo = 0;
	nodo_t* buscado = buscar_padre(arbol, arbol->raiz, clave, &hijo, &padre);
	if(buscado==NULL) return NULL;
	void* dato_borrado = buscado->dato;
	//caso 0 hijos
	if(buscado->izq==NULL && buscado->der==NULL){
		if(buscado==arbol->raiz){
			arbol->raiz = NULL;
		}
		if(hijo==DERECHO){
			padre->der = NULL;
		} 
		if(hijo==IZQUIERDO){
			padre->izq = NULL;
		}
	}
	//caso 1 hijo
	else if(buscado->izq==NULL || buscado->der==NULL){
		if(buscado==arbol->raiz){
			if(buscado->izq==NULL){
				arbol->raiz = buscado->der;
			} else {
				arbol->raiz = buscado->izq;
			}
		}
		else if(buscado->izq==NULL){
			if(hijo==IZQUIERDO) padre->izq = buscado->der;
			if(hijo==DERECHO) padre->der = buscado->der;
		} else { 
			if(hijo==IZQUIERDO) padre->izq = buscado->izq;
			if(hijo==DERECHO) padre->der = buscado->izq;	
		}
	}
	//caso 2 hijos
	if(buscado->izq!=NULL && buscado->der!=NULL){
		nodo_t* reemplazante = buscar_reemplazante(arbol, buscado);
		char* copia_clave;
		copia_clave = reemplazante->clave;
		void* dato_reemplazante = _abb_borrar(arbol, copia_clave);
		buscado->clave = copia_clave;
		buscado->dato = dato_reemplazante;
	}
	arbol->cant--;
	destruir_nodo(buscado);
	return dato_borrado;
}



//Recorre el arbol de forma post-order aplicando la funcion de borrar con el objetivo de destruirlo
void abb_recorrido(abb_t* arbol, nodo_t* nodo){
    if(!nodo) return;
    abb_recorrido(arbol, nodo->der);
    abb_recorrido(arbol, nodo->izq);
    void* borrar = abb_borrar(arbol, nodo->clave);
    if(arbol->destruir_dato) arbol->destruir_dato(borrar);
}

void abb_destruir(abb_t *arbol){   
    abb_recorrido(arbol, arbol->raiz);
    free(arbol);
}


//Iterador interno

bool _abb_in_order(nodo_t* nodo, bool visitar(const char *, void *, void *), void *extra){
	if (!nodo) return true;
	if (!_abb_in_order(nodo->izq, visitar, extra)) return false;
	if (!visitar(nodo->clave, nodo->dato, extra)) return false;
	if (!_abb_in_order(nodo->der, visitar, extra)) return false;
	return true;
}

void abb_in_order(abb_t *arbol, bool visitar(const char *, void *, void *), void *extra){
	if (!arbol) return;
	_abb_in_order(arbol->raiz, visitar, extra);
	return;
}

//Iterador externo

struct abb_iter{
	pila_t* pila;
};

//Apila el nodo recibido y todos sus hijos izquierdos
bool apilar_todos_izq(nodo_t* nodo, pila_t* pila){
	if (!nodo) return true;

	if (!pila_apilar(pila, nodo)) return false;
	if (!apilar_todos_izq(nodo->izq, pila)) return false;
	return true;
}

abb_iter_t* abb_iter_in_crear(const abb_t* arbol){
	abb_iter_t* iter = malloc(sizeof(abb_iter_t));
	if (!iter) return NULL;

	iter->pila = pila_crear();
	if (!iter->pila){
		free(iter);
		return NULL;
	}

	if (!apilar_todos_izq(arbol->raiz, iter->pila)){
		pila_destruir(iter->pila);
		free(iter);
		return NULL;
	}
	return iter;
}

bool abb_iter_in_avanzar(abb_iter_t *iter){
	if (pila_esta_vacia(iter->pila)) return false;

	nodo_t* desapilado = (nodo_t*) pila_desapilar(iter->pila);
	apilar_todos_izq(desapilado->der, iter->pila);
	return true;
}

const char* abb_iter_in_ver_actual(const abb_iter_t *iter){
	nodo_t* nodo = (nodo_t*) pila_ver_tope(iter->pila);
	if (!nodo) return NULL;
	return nodo->clave;
}

bool abb_iter_in_al_final(const abb_iter_t *iter){
	return pila_esta_vacia(iter->pila);
}

void abb_iter_in_destruir(abb_iter_t* iter){
	pila_destruir(iter->pila);
	free(iter);
}
