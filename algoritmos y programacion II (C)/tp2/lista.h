#ifndef LISTA_H
#define LISTA_H

#include <stddef.h>
#include <stdbool.h>



typedef struct lista lista_t;

//Crea una lista
//Post: Devuelve una lista vacia
lista_t *lista_crear(void);


//Devuelve verdadero si la lista no tiene elementos, false en caso contrario
//Pre: la lista fue creada
bool lista_esta_vacia(const lista_t *lista);


//Inserta un elemento en el primer lugar de la lista, devuelve false en caso de algun fallo
//Pre: La lista fue creada
//Post: El elemento insertado esta ubicado en la primera posicion
bool lista_insertar_primero(lista_t *lista, void *dato);


//Inserta un elemento en el ultimo lugar de la lista, devuelve false en caso de algun fallo
//Pre: La lista fue creada
//Post: El elemento insertado esta ubicado en la ultima posicion
bool lista_insertar_ultimo(lista_t *lista, void *dato);


//Elimina el primer elemento de la lista y lo devuelve, si la cola no tiene elementos devuelve NULL
//Pre: La lista fue creada
//Post: Se devuelve el primer valor de la lista, la lista tiene un elemento menos y es el primero
void *lista_borrar_primero(lista_t *lista);


// Obtiene el valor del primer elemento de la lista. Si la lista elementos, se devuelve el valor del primero, si está vacía devuelve NULL.
// Pre: La lista fue creada.
// Post: Se devolvió el primer elemento de la lista, cuando no está vacía.
void *lista_ver_primero(const lista_t *lista);


// Obtiene el valor del ultimo elemento de la lista. Si la lista elementos, se devuelve el valor del ultimo, si está vacía devuelve NULL.
// Pre: Ña lista fue creada.
// Post: Se devolvió el ultimo elemento de la lista, cuando no está vacía.
void *lista_ver_ultimo(const lista_t* lista);


//Devuelve el largo de la lista
//Pre: La lista fue creada
//Devuelve la cantidad de elementos de la lista
size_t lista_largo(const lista_t *lista);

// Destruye la lista, si se recibe la función destruir_dato por parámetro, para cada uno de los elementos de la cola llama a destruir_dato.
// Pre: La lista fue creada, destruir_dato es una función capaz de destruir los datos de la lista, o NULL en caso de que no se la utilice.
// Post: Se eliminaron todos los elementos de la lista.
void lista_destruir(lista_t *lista, void (*destruir_dato)(void *));


//Itera todos los elementos de la lista, recibiendo la funcion visitar por paramentro
//Pre: La lista fue creada
//Post: Se le aplico la funcion visitar a todos los elementos de la lista
void lista_iterar(lista_t *lista, bool visitar(void *dato, void *extra), void *extra);



typedef struct lista_iter lista_iter_t;

//Crea un iterador recibiendo una lista por parametro
//Post: Crea un iterador con el actual apuntando al primer elemento de la lista recibida por parametro
lista_iter_t *lista_iter_crear(lista_t *lista);


// Avanza una posicion en el iterador, devuelve false en caso contrario
//Pre: El iterador fue creado
//Post: Avanza en una posicion el iterador de la lista
bool lista_iter_avanzar(lista_iter_t *iter);


//Obtiene el valor al que le esta apuntando el iterador de la lista
//Pre: El iterador fue creado
//Post: Devuelve el valor al que esta apuntando el actual del iterador
void *lista_iter_ver_actual(const lista_iter_t *iter);


//Dice si el iterador llego al final de la lista
//Pre: El iterador fue creado
//Post: Devuelve true si  la posicion del iterador esta al final de la lista, false  en caso contrario
bool lista_iter_al_final(const lista_iter_t *iter);


//Destruye el iterador
//Pre: El iterador fue creado
void lista_iter_destruir(lista_iter_t *iter);


//Inserta el valor pasado como parametro en la posicion a la que apunta el iterador
//Pre: El iterador fue creado
//Post: Inserta el valor en la posicion a la que apunta el iterador, el iterador apunta al valor insertado, devuelve el false en caso de algun fallo
bool lista_iter_insertar(lista_iter_t *iter, void *dato);

//Devuelve el valor al que esta apuntando el iterador
//Pre: El iterador fue creado
//Post: Se borra el elemento al que estaba apuntando el iterador, el iterador ahora apunta al siguiente elemento de la lista
void *lista_iter_borrar(lista_iter_t *iter);
#endif
