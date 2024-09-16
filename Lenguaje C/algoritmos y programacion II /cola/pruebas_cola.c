#include "cola.h"
#include "testing.h"
#include <stdio.h>
#include <stdlib.h>

static void prueba_crear_destruir(void) {
    	printf("INICIO DE PRUEBAS CREAR Y DESTRUIR COLA\n");
    	cola_t *cola = cola_crear();
    	cola_destruir(cola, NULL);
}

static void prueba_cola_vacia(void) {
	printf("INICIO DE PRUEBAS EL VACIO DE LA COLA\n");
	cola_t* cola = cola_crear();
	print_test("pruebo aque la cola este vacia", cola_esta_vacia(cola) == true);
	int x = 10;
	cola_encolar(cola, &x);
	print_test("pruebo aque la cola no este vacia", cola_esta_vacia(cola) == false);
	cola_encolar(cola, NULL);
	cola_desencolar(cola);
	print_test("pruebo aque la cola no este vacia", cola_esta_vacia(cola) == false);
	cola_desencolar(cola);
	print_test("pruebo aque la cola este vacia", cola_esta_vacia(cola) == true);
	cola_destruir(cola, NULL);
}

static void cola_mantiene_orden(void){
	printf("INICIO DE PRUEBAS SOBRE EL ORDEN DE LA COLA\n");
	cola_t* cola = cola_crear();
	int x = 10;
	int c = 5;
	double y = 1.458;
	cola_encolar(cola, &x);
	cola_encolar(cola, &c);
	cola_encolar(cola, &y);
	print_test("pruebo que el orden este bien", cola_ver_primero(cola) == &x);
	cola_desencolar(cola);
	print_test("pruebo que el orden este bien", cola_ver_primero(cola) == &c);
	print_test("pruebo aque la cola no este vacia", cola_esta_vacia(cola) == false);
	cola_desencolar(cola);	
	print_test("pruebo que el orden este bien", cola_desencolar(cola) == &y);	
	print_test("pruebo aque la cola este vacia", cola_esta_vacia(cola) == true);
	cola_destruir(cola, NULL);
}

static void cola_muchos_elementos(void){
	printf("INICIO DE PRUEBAS CON MUCHOS ELEMENTOS\n");
    	cola_t *cola = cola_crear();
   	int t = 0;
    	for(int i=0;i<100000;i++){  
    	cola_encolar(cola, &t + i);
    }
    	printf("Se encolaron todos los 100.000 elementos\n");   
    	for(int i=0;i<100000;i++){ 
    		cola_desencolar(cola);
    	}
    	printf("Se desencolaron todos los 100.000 elementos\n");
    	int i = 10;
    	print_test("pruebo a encolar algo con la cola vaciada", cola_encolar(cola, &i));
     
    	cola_destruir(cola, NULL);
}


static void prueba_desencolar_ver_primero(void) {
    	printf("INICIO DE PRUEBAS SOBRE CONDICIONES BORDE\n");
    	cola_t *cola = cola_crear();
    	print_test("pruebo que no se puede desaencolar una cola vacia", cola_desencolar(cola) == NULL);
   	 print_test("pruebo que no se puede ver el primero de una cola vacia", cola_ver_primero(cola) == NULL);    
    	cola_destruir(cola, NULL);
}

static void prueba_desencolar_ver_primero_usada(void) {
    	printf("INICIO DE PRUEBAS SOBRE CONDICIONES BORDE\n");
    	cola_t *cola = cola_crear();
    	int i = 10;
   	double c = 1.42;
    	cola_encolar(cola, &i);
   	cola_encolar(cola, &c);
   	cola_desencolar(cola);
   	cola_desencolar(cola);
    	print_test("pruebo que no se puede desaencolar una cola vacia", cola_desencolar(cola) == NULL);
   	print_test("pruebo que no se puede ver el primero de una cola vacia", cola_ver_primero(cola) == NULL);    
    	cola_destruir(cola, NULL);
} 

static void prueba_encolar_null(void) {
    	printf("PRUEBO A ENCOLAR Y DESENCOLAR NULL\n");
    	cola_t *cola = cola_crear();
   	cola_encolar(cola, NULL);
    	print_test("pruebo que la cola no este vacia", cola_esta_vacia(cola) == false);
    	print_test("pruebo que no se puede desencolar una cola vacia", cola_desencolar(cola) == NULL);
    	print_test("pruebo encolar NULL", cola_encolar(cola, NULL));
    	print_test("pruebo encolar NULL", cola_encolar(cola, NULL));
    	print_test("pruebo que la cola no este vacia", cola_esta_vacia(cola) == false);
    	cola_destruir(cola, NULL);
}

static void prueba_cola_destruir(void){
    	printf("PRUEBO A DESTRUIR LA COLA CON OTRA FUNCION\n");
    	cola_t *cola = cola_crear();
    	void* x = malloc(sizeof(int));
	void* c = malloc(sizeof(int));
	void* y = malloc(sizeof(int));
	cola_encolar(cola, x);
	cola_encolar(cola, c);
	cola_encolar(cola, y);
	cola_destruir(cola, free);
	printf("Se libero la memoria dinamica dentro de la cola\n");
}
    
    
void pruebas_cola_estudiante() {
	prueba_crear_destruir();
    	prueba_cola_vacia();
    	cola_mantiene_orden();
    	cola_muchos_elementos();
    	prueba_desencolar_ver_primero();
    	prueba_desencolar_ver_primero_usada();
    	prueba_encolar_null();
    	prueba_cola_destruir();
}


/*
 * Función main() que llama a la función de pruebas.
 */

#ifndef CORRECTOR  // Para que no dé conflicto con el main() del corrector.

int main(void) {
    pruebas_cola_estudiante();
    return failure_count() > 0;  // Indica si falló alguna prueba.
}

#endif
