#ifndef PROCESAR_USUARIOS_H
#define PROCESAR_USUARIOS_H

#include <stddef.h>
#include <stdbool.h>
#include "lista.h"
#include "hash.h"
#include "strutil.h"


typedef struct usuario usuario_t;

typedef struct counting counting_t;

//Crea un count
//Tendra dos diccionarios con todas las letras como clave y 0 como valor
counting_t* crear_count(void);


//A partir de una lista tomada como referencia, llena los diccionarios del count
//de posiciones y sumas acumuladas
void llenar_count(counting_t* count, hash_t* usuarios, lista_t* lista, int pos);


//Destruye el count
void destruir_count(counting_t* count);


//Crea un usuario pasandole por parametro el nombre del mismo
//Pre: El nombre es valido
//Post: Devuelve el usuario 
usuario_t* crear_usuario(char* nombre);


//Destruye el usuario
void destruir_usuario(usuario_t* usuario);


//Crea un usuario y lo agrega al diccionario usuarios pasado por parametro
//Pre: La linea recibida es valida y el diccionario usuarios fue creado
//Post: Si el usuario no fue creado, se crea el usuario,
//si no fue creado solamente se le agregan solamente sus tweets nuevos
void agregar_usuario(char* linea, hash_t* usuarios);


//Destruye todos los usuarios contenidos en el diccionario de usuarios
//Pre: El diccionario fue creado y todos sus datos son usuarios
//Post: Todos los usuarios del diccionario fueron destruidos
void destruir_usuarios(hash_t* usuarios);


//Calcula el rango de distintos tweets usados por los usuarios dejando en los punteros de minimo y maximo los respectivos valores
//Pre: El diccionario usuarios fue creado
//Post: Los punteros min y max ahora contienen los valores del rango
void calcular_rango(hash_t* usuarios, size_t *min, size_t *max);

//Devuelve el diccionario baldes, que tendra como clave la cantidad de tweets usados por los usuarios y como dato todos los nombres de esos usuarios
//Pre: El diccionario usuarios fue creado
//Post: Se devuelve el diccionario baldes, en caso de ocurrir un fallo se devuelve NULL
hash_t* llenar_baldes(hash_t* usuarios, size_t min, size_t max);


//Se ordenan las los baldes
//Pre: Los diccionarios baldes y usuarios fueron creados
//Post: Se ordeno el diccionario baldes
void ordenar_baldes(hash_t* baldes, hash_t* usuarios);

//Se ordena la lista contenida como dato en cada balde aplicando Radix Sort
//Pre: El diccionario usuarios fue creado y tambien la lista
//Post: Se ordeno la lista
void ordenar_lista(hash_t* usuarios, lista_t* lista);

//Se ordena cada palabra de la lista tomando como referencia solo una letra usando Counting Sort
//Pre: El diccionario usuarios y la lista fueron creados
//Post: Se ordeno la lista a partir de la letra ubicada en el parametro pos
void ordenar_letra(hash_t* usuarios, lista_t* lista, int pos);

//Imprime por pantalla todos los baldes
//Pre: El diccionario baldes y usuarios ya fueron creados y ordenados
//Post: Se imprimieron por pantalla todos los baldes
void imprimir_baldes(hash_t* baldes, size_t min, size_t max, hash_t* usuarios);

//LLama a las funciones de calcular rango, llenar baldes, ordenar baldes e imprimir baldes
//Pre: El diccionario usuarios fue creado
//Post: Se imprimio por pantalla el resultado de procesar_usuarios
void imprimir_usuarios(hash_t* usuarios);

//Abre el archivo, lee linea por linea agregando el usuario y despues imprime el resultado por pantalla
//Pre: La funcion main recibio un nombre de archivo valido
//Post: Se imprimieron los usuarios por pantalla
void procesar_usuarios(char* nombre_archivo);
#endif

























