#include "pila.h"
#include "testing.h"
#include <stdio.h>

static void prueba_crear_destruir(void) {
    printf("INICIO DE PRUEBAS CREAR Y DESTRUIR PILA\n");
    pila_t *pila = pila_crear();
    pila_destruir(pila);
}

static void prueba_pila_mantiene_orden(void) {
    printf("INICIO DE PRUEBAS DE EL CORRECTO ORDEN DE LA PILA\n");
    pila_t *pila = pila_crear();
    int i = 10;
    int f = 5;
    int g = 1;
    double c = 1.42;
    pila_apilar(pila, &c);
    pila_apilar(pila, &g);
    pila_apilar(pila, &f);
    pila_apilar(pila, &i);
    for(int x = 0; x<4;x++){
    	if(pila_ver_tope(pila) == pila_desapilar(pila)){
    		printf("El tope coincide con lo desapilado\n");
    	}
    }
    pila_apilar(pila, &c);
    pila_apilar(pila, &g);
    pila_apilar(pila, &f);
    pila_apilar(pila, &i);  
    pila_desapilar(pila);
    pila_desapilar(pila);
    print_test("pruebo que se mantiene el mismo orden al desapilar", pila_desapilar(pila) == &g);
    print_test("pruebo que se mantiene el mismo orden al desapilar", pila_desapilar(pila) == &c);
    
    pila_destruir(pila);
}



static void prueba_apilar_null(void) {
    printf("PRUEBO A APILAR Y DESAPILAR NULL\n");
    pila_t *pila = pila_crear();
    pila_apilar(pila, NULL);
    print_test("pruebo que la pila no este vacia", pila_esta_vacia(pila) == false);
    print_test("pruebo que no se puede desapilar una pila vacia", pila_desapilar(pila) == NULL);
    print_test("pruebo apilar NULL", pila_apilar(pila, NULL));
    print_test("pruebo apilar NULL", pila_apilar(pila, NULL));
    print_test("pruebo que la pila no este vacia", pila_esta_vacia(pila) == false);
    pila_destruir(pila);
}


static void prueba_muchos_elementos(void) {
    printf("INICIO DE PRUEBAS CON MUCHOS ELEMENTOS\n");
    pila_t *pila = pila_crear();
    int t = 0;
    size_t contador = 0;
    for(int i=0;i<50000;i++){  
    	pila_apilar(pila, &t + i);
    	if(pila_ver_tope(pila) == (&t + i)){
    		contador++;
    	}
    }
    double z = 1.50;
    pila_apilar(pila, &z);
    print_test("pruebo que se sigue manteniendo el orden de la pila", pila_ver_tope(pila) == &z);    
    for(int i=0;i<50000;i++){
    	pila_apilar(pila, &t + i);
    	if(pila_ver_tope(pila) == (&t + i)){
    		contador++;
    	}
    }
    double y = 5.50;
    pila_apilar(pila, &y);
    print_test("pruebo que se sigue manteniendo el orden de la pila", pila_ver_tope(pila) == &y);   
    print_test("Se apilaron todos los 100.000 elementos", contador==100000);   
    for(int i=0;i<100000;i++){ 
    	pila_desapilar(pila);
    }
    printf("Se desapilaron todos los 100.000 elementos\n");
    int i = 10;
    print_test("pruebo a apilar algo con la pila vaciada", pila_apilar(pila, &i));
     
    pila_destruir(pila);
}

static void prueba_desapilar_la_reinicia(void) {
    printf("INICIO DE PRUEBAS SOBRE CONDICIONES BORDE\n");
    pila_t *pila = pila_crear();
    int i = 10;
    double c = 1.42;
    pila_apilar(pila, &i);
    pila_apilar(pila, &c);
    pila_desapilar(pila);
    pila_desapilar(pila);
    print_test("pruebo que la pila este vacia", pila_esta_vacia(pila) == true);
    pila_apilar(pila, &i);
    print_test("pruebo que la pila no este vacia", pila_esta_vacia(pila) == false);
    pila_desapilar(pila);
    print_test("pruebo que la pila este vacia", pila_esta_vacia(pila) == true);
    pila_destruir(pila);
}

static void prueba_dasapilar_ver_tope(void) {
    printf("INICIO DE PRUEBAS SOBRE CONDICIONES BORDE\n");
    pila_t *pila = pila_crear();
    print_test("pruebo que no se puede desapilar una pila vacia", pila_desapilar(pila) == NULL);
    print_test("pruebo que no se puede ver el tope de una pila vacia", pila_ver_tope(pila) == NULL);    
    pila_destruir(pila);
}

static void prueba_desapilar_ver_tope_usada(void) {
    printf("INICIO DE PRUEBAS SOBRE CONDICIONES BORDE\n");
    pila_t *pila = pila_crear();
    int i = 10;
    double c = 1.42;
    pila_apilar(pila, &i);
    pila_apilar(pila, &c);
    pila_desapilar(pila);
    pila_desapilar(pila);
    print_test("pruebo que no se puede desapilar una pila vacia", pila_desapilar(pila) == NULL);
    print_test("pruebo que no se puede ver el tope de una pila vacia", pila_ver_tope(pila) == NULL);    
    pila_destruir(pila);
}


    
void pruebas_pila_estudiante() {
    prueba_crear_destruir();
    prueba_pila_mantiene_orden();
    prueba_muchos_elementos();
    prueba_apilar_null();
    prueba_desapilar_la_reinicia();
    prueba_dasapilar_ver_tope();
    prueba_desapilar_ver_tope_usada();
}


/*
 * Función main() que llama a la función de pruebas.
 */

#ifndef CORRECTOR  // Para que no dé conflicto con el main() del corrector.

int main(void) {
    pruebas_pila_estudiante();
    return failure_count() > 0;  // Indica si falló alguna prueba.
}

#endif
