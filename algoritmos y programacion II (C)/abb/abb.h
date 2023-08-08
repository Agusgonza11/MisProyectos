#ifndef ABB_H
#define ABB_H

#include <stddef.h>
#include <stdbool.h>

/* ******************************************************************
 *                DEFINICION DE LOS TIPOS DE DATOS
 * *****************************************************************/
void pruebas_abb_estudiante();

typedef struct abb abb_t;

typedef int (*abb_comparar_clave_t) (const char *, const char *);
typedef void (*abb_destruir_dato_t) (void *);

typedef struct abb_iter abb_iter_t;

//Crea el arbol
//Post: Devuelve un abb vacio
abb_t* abb_crear(abb_comparar_clave_t cmp, abb_destruir_dato_t destruir_dato);


//Guarda el dato y la clave en el arbol en su orden correcto
//Pre: El arbol fue creado
//Post: En el caso de que la clave no exista en el arbol crea un nodo con la clave
//y el valor, en caso contrario intercambia el nuevo dato por el antiguo y liberando
//esa memoria en caso de que sea dinamica
bool abb_guardar(abb_t *arbol, const char *clave, void *dato);

//Destruye el nodo con la clave pasada por parametro
//Pre: El arbol fue creado
//Post: En caso de que la clave pertenezca al arbol, se destruye su nodo y devuelve su dato,
//en caso contrario devuelve NULL
void *abb_borrar(abb_t *arbol, const char *clave);

//Obtiene el dato asociado a la clave pasada por parametro
//Pre: El arbol fue creado
//Post: En caso de que la clave pertenezca al arbol devuelve su dato,
//en caso contrario devuelve NULL
void *abb_obtener(const abb_t *arbol, const char *clave);

//Devuelve un booleano indicando si la clave buscada esta almacenada en el arbol
//Pre: El arbol fue creado
//Post: Si la clave esta guardada en el arbol devuelve true, en caso contrario devuelve false
bool abb_pertenece(const abb_t *arbol, const char *clave);

//Devuelve la cantidad de elementos almacenados en el arbol
//Pre: El arbol fue creado
//Post: Devuelve un size_t con la cantidad de elementos guardados en el abb
size_t abb_cantidad(const abb_t *arbol);

//Destrue todos los nodos almacenados en el arbol
//Pre: El arbol fue creado
//Post: Se libero la memoria del arbol y de sus nodos si los poseia
void abb_destruir(abb_t *arbol);


//Itera al abb en recorrido in-order ejecutando la funcion "visitar" con los elementos del mismo.
//Esta funcion "visitar" debe recibir como parametro el puntero a la clave del elemento, 
//el puntero al dato almacenado con esa clave y un puntero a una variable extra para almacenar
//resultados anteriores de su ejecucion, ademas debe devolver un booleano indicando si se debe seguir iterando,
//con true indica que hay que seguir y con false que hay que dejar de iterar.
//pre: el abb fue creado, existe la funcion visitar.
//post: Se ejecuto la funcion visitar con los elementos del abb.
void abb_in_order(abb_t *arbol, bool visitar(const char *, void *, void *), void *extra);


/* ******************************************************************
 *                 PRIMITIVAS DEL ITERADOR EXTERNO
 * *****************************************************************/

//Crea el iterador de un abb.
//pre: el abb fue creado.
//post: devuelve el iterador del abb posicionado en el primer elemento en recorrido in-order
//		o NULL si hubo algun problema al crearlo.
abb_iter_t *abb_iter_in_crear(const abb_t *arbol);

//Avanza un elemento en recorrido in-order, devuelve true si logro avanzar, y
//false si no lo logro (lo que sigunifica que estaba en el final de la iteracion).
//Pre: el iterador y el abb fueron creados.
bool abb_iter_in_avanzar(abb_iter_t *iter);

// Obtiene el valor del elemento del abb en el cual esta el iterador, o NULL si el iterador esta al final.
//Pre: el iterador y el abb fueron creados.
const char *abb_iter_in_ver_actual(const abb_iter_t *iter);

//Devuelve true si el iterador llego al final del recorrido, false si no.
//Pre: el iterador y el abb fueron creados.
bool abb_iter_in_al_final(const abb_iter_t *iter);

//Destruye el iterador
//Pre: el iterador fue creado.
void abb_iter_in_destruir(abb_iter_t* iter);

#endif
