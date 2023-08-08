#include "lista.h"
#include "testing.h"
#include <stdio.h>

static void prueba_crear_destruir(void){
	printf("INICIO DE PRUEBAS CREAR Y DESTRUIR LISTA\n");
	lista_t *lista = lista_crear();
	lista_destruir(lista, NULL);
}

static void prueba_lista_mantiene_orden(void){
	printf("INICIO DE PRUEBAS SOBRE EL ORDEN DE LA LISTA\n");
	lista_t *lista = lista_crear();
	int x = 10;
	double y = 1.50;
	lista_insertar_primero(lista, &x);
	print_test("pruebo que se inserto correctamente", lista_ver_primero(lista) == &x);
	lista_insertar_primero(lista, &y);
	print_test("pruebo que se inserto correctamente", lista_ver_primero(lista) == &y);
	print_test("pruebo que se inserto correctamente", lista_ver_ultimo(lista) == &x);
	int z = 50;
	lista_insertar_ultimo(lista, &z);
	print_test("pruebo que se inserto correctamente", lista_ver_ultimo(lista) == &z);
	lista_destruir(lista, NULL);
}
    
static void prueba_largo_lista(void){
	printf("INICIO DE PRUEBAS SOBRE EL LARGO DE LA LISTA\n");
	lista_t *lista = lista_crear();
	print_test("pruebo que el largo es correcto", lista_largo(lista) == 0);
	int x = 10;
	double y = 1.50;
	int z = 50;
	lista_insertar_primero(lista, &x);
	lista_insertar_primero(lista, &y);
	print_test("pruebo que el largo es correcto", lista_largo(lista) == 2);
	lista_insertar_ultimo(lista, &z);
	print_test("pruebo que el largo es correcto", lista_largo(lista) == 3);
	lista_destruir(lista, NULL);
}

static void prueba_insertar_null(void){
    	printf("PRUEBO A INSERTAR Y BORRAR NULL\n");
    	lista_t *lista = lista_crear();
    	lista_insertar_primero(lista, NULL);
   	print_test("pruebo que la lista no este vacia", lista_esta_vacia(lista) == false);
   	print_test("pruebo que no se puede borrar una lista vacia", lista_borrar_primero(lista) == NULL);
    	print_test("pruebo insertar NULL", lista_insertar_ultimo(lista, NULL));
    	print_test("pruebo insertar NULL", lista_insertar_ultimo(lista, NULL));
    	print_test("pruebo que no se puede borrar una lista vacia", lista_borrar_primero(lista) == NULL);
    	lista_destruir(lista, NULL);
}

static void prueba_lista_bordes(void){
   	printf("PRUEBO LOS PRIMEROS Y ULTIMOS\n");
    	lista_t *lista = lista_crear();
    	int x = 10;
	double y = 1.50;
	lista_insertar_primero(lista, &x);
	lista_insertar_ultimo(lista, &y);
	lista_borrar_primero(lista);
	print_test("pruebo que se mantiene el orden", lista_ver_primero(lista) == lista_ver_ultimo(lista));
	print_test("pruebo que se mantiene el orden", lista_ver_primero(lista) == &y);
	lista_destruir(lista, NULL);
}


static void prueba_muchos_elementos(void) {
    printf("INICIO DE PRUEBAS CON MUCHOS ELEMENTOS\n");
    lista_t *lista = lista_crear();
    for(int i=0;i<50000;i++){
    	int* x = &i;
    	lista_insertar_primero(lista, &x);
    }
    double z = 1.50;
    lista_insertar_primero(lista, &z);
    print_test("pruebo que se sigue manteniendo el orden de la lista", lista_ver_primero(lista) == &z);    
    for(size_t i=0;i<50000;i++){
    	size_t* x = &i;
    	lista_insertar_ultimo(lista, &x);
    }
    double y = 5.50;
    lista_insertar_ultimo(lista, &y);
    print_test("pruebo que se sigue manteniendo el orden de la lista", lista_ver_ultimo(lista) == &y);   
    printf("Se insertaron todos los 100.000 elementos\n");   
    for(int i=0;i<100000;i++){ 
    	lista_borrar_primero(lista);
    }
    printf("Se borraron todos los 100.000 elementos\n");  
    lista_destruir(lista, NULL);
}


//inicio de pruebas sobre iterador externo

static void prueba_iterador_insertar(void){
    	printf("INICIO DE PRUEBAS INSERTANDO CON ITERADOR \n");
	int x = 10;
	double y = 1.50;
	int z = 60;
	int t = 88;
	lista_t *lista = lista_crear();
	lista_insertar_primero(lista, &x);
	lista_iter_t* iter =  lista_iter_crear(lista);
	print_test("pruebo que se inserta correctamente", lista_iter_ver_actual(iter)== &x);
	lista_iter_insertar(iter, &y);
	print_test("pruebo que se inserta correctamente", lista_iter_ver_actual(iter) == &y);
	print_test("pruebo que se mantiene el orden", lista_ver_ultimo(lista) == &x);
	lista_iter_avanzar(iter);
	print_test("pruebo que no llego al final", lista_iter_al_final(iter) == false);
	lista_iter_insertar(iter, &z);
	print_test("pruebo que se inserta correctamente", lista_iter_ver_actual(iter) == &z);
	lista_iter_avanzar(iter);
	print_test("pruebo que se mantiene el orden", lista_iter_ver_actual(iter)== &x);
	lista_iter_avanzar(iter);
	print_test("pruebo que llego al final", lista_iter_al_final(iter) == true);
	lista_iter_insertar(iter, &t);
	print_test("pruebo que cuando el iterador llego al final inserta en el ultimo lugar", &t == lista_iter_ver_actual(iter));
	lista_destruir(lista, NULL);
	lista_iter_destruir(iter);
}

static void prueba_iterador_borrar(void){
    	printf("INICIO DE PRUEBAS BORRANDO CON ITERADOR \n");
	int x = 10;
	double y = 1.50;
	int z = 60;
	lista_t *lista = lista_crear();
	lista_iter_t* iter =  lista_iter_crear(lista);
	lista_iter_insertar(iter, &x);
	lista_iter_insertar(iter, &y);
	lista_iter_insertar(iter, &z);	
	print_test("pruebo que el orden es correcto", lista_iter_ver_actual(iter)== &z);	
	print_test("pruebo que se mantiene el orden", lista_ver_ultimo(lista) == &x);
	print_test("pruebo que se mantiene el orden", lista_ver_primero(lista) == &z);	
	lista_iter_borrar(iter);
	print_test("pruebo que se mantiene el orden", lista_ver_primero(lista) == &y);
	lista_iter_borrar(iter);
	print_test("pruebo que se mantiene el orden", lista_ver_ultimo(lista) == &x);	
	print_test("pruebo que el orden es correcto", lista_iter_ver_actual(iter)== &x);
	lista_iter_insertar(iter, &y);
	lista_iter_avanzar(iter);	
	lista_iter_borrar(iter);
	print_test("pruebo que se mantiene el orden", lista_ver_ultimo(lista) == &y);
	print_test("pruebo que se mantiene el orden", lista_ver_primero(lista) == &y);
	print_test("elimino el ultimo y el primero", lista_iter_borrar(iter) == NULL);
	print_test("pruebo que el orden es correcto", lista_iter_ver_actual(iter)== NULL);
   	print_test("pruebo que lo que queda es el mismo elemento", lista_ver_ultimo(lista)== lista_ver_primero(lista));	
	lista_destruir(lista, NULL);
	lista_iter_destruir(iter);
}

bool sumar_datos(void* dato, void* extra){
 	*(int*) extra += *(int*) dato;
	return true;
}

static void prueba_iterador_interno(void){
    	printf("INICIO DE PRUEBAS CON ITERADOR INTERNO \n");
	int x = 20;
	int z = 30;
	lista_t *lista = lista_crear();
	lista_iter_t* iter =  lista_iter_crear(lista);
	lista_iter_insertar(iter, &x);
	lista_iter_insertar(iter, &z);	
	int suma = 0;
	lista_iterar(lista, sumar_datos, &suma);
	print_test("pruebo que se modifico el elemento suma", suma == 50);	
	lista_iter_borrar(iter);
	lista_iter_borrar(iter);
	lista_destruir(lista, NULL);
	lista_iter_destruir(iter);
}


void pruebas_lista_estudiante() {
    	prueba_crear_destruir();
    	prueba_lista_mantiene_orden();
    	prueba_largo_lista();
    	prueba_lista_bordes();
    	prueba_insertar_null();
    	prueba_muchos_elementos();
    	prueba_iterador_insertar();
    	prueba_iterador_borrar();
    	prueba_iterador_interno();
}



#ifndef CORRECTOR  // Para que no dé conflicto con el main() del corrector.

int main(void) {
    pruebas_lista_estudiante();
    return failure_count() > 0;  // Indica si falló alguna prueba.
}

#endif
