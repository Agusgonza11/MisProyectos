#include "abb.h"
#include "testing.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int comparar_enteros(const char* clave_1, const char* clave_2){
	int c1 = atoi(clave_1);
	int c2 = atoi(clave_2);
	if (c1 == c2) return 0;
	return c2 < c1 ? 1 : -1;
}

static void prueba_abb_vacio(){
	abb_t* abb = abb_crear(comparar_enteros, NULL);
	print_test("Se pudo crear el arbol", abb != NULL);
	print_test("El arbol esta vacio al crearlo", abb_cantidad(abb) == 0);
	print_test("Prueba abb obtener clave 1, es NULL, no existe", !abb_obtener(abb, "1"));
	print_test("Prueba abb pertenece clave 1, es false, no existe", !abb_pertenece(abb, "1"));
	abb_destruir(abb);
}

static void prueba_unico_elem(){
	abb_t* abb = abb_crear(comparar_enteros, NULL);
	int a = 1;
	print_test("El elemento 1 no pertenece al arbol", !abb_pertenece(abb, "1"));
	print_test("Se pudo guardar el elemento 1", abb_guardar(abb, "1", &a));
	print_test("Ahora la cantidad de nodos es 1", abb_cantidad(abb) == 1);
	print_test("Ahora el elemento 1 pertenece al arbol", abb_pertenece(abb, "1"));
	print_test("Al intentar obtener el elemento 1, recibo el puntero que guarde", abb_obtener(abb, "1") == &a);
	print_test("Al borrar el elemento 1 recibo el puntero que guarde", abb_borrar(abb, "1") == &a);
	print_test("Ahora el elemento 1 no pertenece al arbol", !abb_pertenece(abb, "1"));
	print_test("Ahora al intentar borrar el elemento 1 recibo NULL", abb_borrar(abb, "1") == NULL);
	print_test("Ahora el arbol esta vacio", abb_cantidad(abb) == 0);
	abb_destruir(abb);
}

static void prueba_abb_guardar()
{
    abb_t* abb = abb_crear(comparar_enteros, NULL);

    char* A = "1";
    char* B = "2"; 
    char* C = "3";
    char* valor_A = "A";
    char* valor_B = "B";
    char* valor_C = "C";

    print_test("Se pudo guardar A", abb_guardar(abb, A, valor_A));
    print_test("Ahora la cantidad de elementos es 1", abb_cantidad(abb) == 1);
    print_test("Al obtener A recibo valor_A", abb_obtener(abb, A) == valor_A);
    print_test("Ahora A pertenece al abb", abb_pertenece(abb, A));
    print_test("Al borrar A, recibo valor_A", abb_borrar(abb, A) == valor_A);
    print_test("Ahora la cantidad de elementos es 0", abb_cantidad(abb) == 0);
    print_test("Se pudo guardar B", abb_guardar(abb, B, valor_B));
    print_test("Ahora la cantidad de elementos es 1", abb_cantidad(abb) == 1);
    print_test("Al obtener B, recibo valor_B", abb_obtener(abb, B) == valor_B);
    print_test("Ahora B pertenece al abb", abb_pertenece(abb, B));
    print_test("C no pertenece al abb", !abb_pertenece(abb, C));
    print_test("Se pudo guardar C", abb_guardar(abb, C, valor_C));
    print_test("Ahora la cantidad de elementos es 2", abb_cantidad(abb) == 2);
    print_test("Al obtener C recibo valor_C", abb_obtener(abb, C) == valor_C);
    print_test("Ahora C pertenece al abb", abb_pertenece(abb, C));
    print_test("Al borrar C recibo valor_C", abb_borrar(abb, C) == valor_C);
    print_test("Ahora C ya no pertenece al abb", !abb_pertenece(abb, C));
    print_test("Ahora la cantidad de elementos es 1", abb_cantidad(abb) == 1);
    print_test("Se pudo guardar A", abb_guardar(abb, A, valor_A));
    print_test("Ahora la cantidad de elementos es 2", abb_cantidad(abb) == 2);
    print_test("Se pudo guardar C", abb_guardar(abb, C, valor_C));
    print_test("Ahora la cantidad de elementos es 3", abb_cantidad(abb) == 3);
    print_test("Al borrar C recibo valor_C", abb_borrar(abb, C) == valor_C);
    print_test("Ahora la cantidad de elementos es 2", abb_cantidad(abb) == 2);
    print_test("A y B siguen perteneciendo al abb", abb_pertenece(abb, A) && abb_pertenece(abb, B));
    print_test("Al borrar A recibo valor_A", abb_borrar(abb, A) == valor_A);
    print_test("Al intentar borrar A denuevo recibo NULL", abb_borrar(abb, A) == NULL);
    print_test("Al borrar B recibo valor_B", abb_borrar(abb, B) == valor_B);

    abb_destruir(abb);
}

static void prueba_abb_reemplazar(){
	abb_t* abb = abb_crear(comparar_enteros, NULL);

    char* A = "1";
    char* B = "2"; 

    char* valor_A_1 = "A";
    char* valor_B_1 = "B";

    char* valor_A_2 = "a";
    char* valor_B_2 = "b";

    print_test("Se pudo guardar A con el valor_A_1", abb_guardar(abb, A, valor_A_1));
    print_test("Al obtener A, recibo valor_A_1", abb_obtener(abb, A) == valor_A_1);
    print_test("La cantidad de elementos es 1", abb_cantidad(abb) == 1);
    print_test("A pertenece al abb", abb_pertenece(abb, A));
    print_test("B no pertenece al abb", !abb_pertenece(abb, B));
    print_test("Pude guardar B con el valor_B_1", abb_guardar(abb, B, valor_B_1));
    print_test("Al obtener B, recibo valor_B_1", abb_obtener(abb, B) == valor_B_1);
    print_test("Ahora B pertenece al abb", abb_pertenece(abb, B));
    print_test("Ahora la cantidad de elementos es 2", abb_cantidad(abb) == 2);

    print_test("Se pudo cambiar el valor de A al valor_A_2", abb_guardar(abb, A, valor_A_2));
    print_test("Ahora al obtener A, recibo el valor_A_2", abb_obtener(abb, A) == valor_A_2);
    print_test("A sigue perteneciendo al abb", abb_pertenece(abb, A));
    print_test("La cantidad de elementos sigue siendo 2", abb_cantidad(abb) == 2);
    print_test("Se pudo cambiar el valor de B al valor_B_2", abb_guardar(abb, B, valor_B_2));
    print_test("Ahora al obtener B, recibo el valor_B_2", abb_obtener(abb, B) == valor_B_2);
    print_test("B sigue perteneciendo al abb", abb_pertenece(abb, B));
    print_test("La cantidad de elementos sigue siendo 2", abb_cantidad(abb) == 2);
    print_test("Al borrar A recibo el valor_A_2", abb_borrar(abb, A) == valor_A_2);
    print_test("Ahora la cantidad de elementos es 1", abb_cantidad(abb) == 1);
    print_test("Al intentar obtener A, recibo NULL", abb_obtener(abb, A) == NULL);
    print_test("A ya no pertenece al abb", !abb_pertenece(abb, A));
    print_test("Al borrar B recibo valor_B_2", abb_borrar(abb, B) == valor_B_2);
    print_test("Ahora la cantidad de elementos es 0", abb_cantidad(abb) == 0);

    abb_destruir(abb);
}

static void prueba_abb_reemplazar_con_destruir_dato(){
	abb_t* abb = abb_crear(comparar_enteros, free);

    char* A = "1";
    char* B = "2"; 

    char* valor_A_1 = malloc(2 * sizeof(char));
    char* valor_B_1 = malloc(2 * sizeof(char));
    valor_A_1 = "A";
    valor_B_1 = "B";

    char* valor_A_2 = malloc(2 * sizeof(char));
    char* valor_B_2 = malloc(2 * sizeof(char));
    valor_A_2 = "a";
    valor_B_2 = "b";

    print_test("Se pudo guardar A con el valor_A_1", abb_guardar(abb, A, valor_A_1));
    print_test("Al obtener A, recibo valor_A_1", abb_obtener(abb, A) == valor_A_1);
    print_test("La cantidad de elementos es 1", abb_cantidad(abb) == 1);
    print_test("A pertenece al abb", abb_pertenece(abb, A));
    print_test("B no pertenece al abb", !abb_pertenece(abb, B));
    print_test("Pude guardar B con el valor_B_1", abb_guardar(abb, B, valor_B_1));
    print_test("Al obtener B, recibo valor_B_1", abb_obtener(abb, B) == valor_B_1);
    print_test("Ahora B pertenece al abb", abb_pertenece(abb, B));
    print_test("Ahora la cantidad de elementos es 2", abb_cantidad(abb) == 2);
    
    print_test("Se pudo cambiar el valor de A al valor_A_2", abb_guardar(abb, A, valor_A_2));
    print_test("Ahora al obtener A, recibo el valor_A_2", abb_obtener(abb, A) == valor_A_2);
    print_test("A sigue perteneciendo al abb", abb_pertenece(abb, A));
    print_test("La cantidad de elementos sigue siendo 2", abb_cantidad(abb) == 2);
    print_test("Se pudo cambiar el valor de B al valor_B_2", abb_guardar(abb, B, valor_B_2));
    print_test("Ahora al obtener B, recibo el valor_B_2", abb_obtener(abb, B) == valor_B_2);
    print_test("B sigue perteneciendo al abb", abb_pertenece(abb, B));
    print_test("La cantidad de elementos sigue siendo 2", abb_cantidad(abb) == 2);
    print_test("Al borrar A recibo el valor_A_2", abb_borrar(abb, A) == valor_A_2);
    print_test("Ahora la cantidad de elementos es 1", abb_cantidad(abb) == 1);
    print_test("Al intentar obtener A, recibo NULL", abb_obtener(abb, A) == NULL);
    print_test("A ya no pertenece al abb", !abb_pertenece(abb, A));
    print_test("Al borrar B recibo valor_B_2", abb_borrar(abb, B) == valor_B_2);
    print_test("Ahora la cantidad de elementos es 0", abb_cantidad(abb) == 0);

    abb_destruir(abb);
}

static void prueba_abb_valor_NULL(){
	abb_t* abb = abb_crear(comparar_enteros, NULL);

	char* A = "";
	char* valor_A = NULL;

	print_test("Se pudo insertar una clave vacia con valor NULL", abb_guardar(abb, A, valor_A));
	print_test("La cantidad de elementos es 1", abb_cantidad(abb) == 1);
	print_test("Al intentar obtener la clave vacia, recibo el puntero a NULL que guarde", abb_obtener(abb, A) == valor_A);
	print_test("La clave vacia pertenece al abb", abb_pertenece(abb, A));
	print_test("Al borrar la clave vacia recibo el puntero a NULL guardado", abb_borrar(abb, A) == valor_A);
	print_test("Ahora la cantidad de elementos es 0", abb_cantidad(abb) == 0);

	abb_destruir(abb);
}

static void prueba_destruir_vacio_sin_funcion(){
	//Destruyo uno vacio sin funcion para destruir elementos
	abb_t* abb = abb_crear(comparar_enteros, NULL);
	abb_destruir(abb);
	print_test("Se destruyo un abb vacio", true);
}

static void prueba_destruir_no_vacio_sin_funcion(){
	//Destruyo uno con elementos pero sin funcion para destruir elementos
	bool guardar = true;
	int arreglo[3];
	abb_t* abb = abb_crear(comparar_enteros, NULL);
	char str[2];
	for (int i = 0; i < 3; i++){
		sprintf(str, "%d", i);
		guardar &= abb_guardar(abb, str, &arreglo[i]);
	}
	print_test("Se pudieron guardar 3 elementos", guardar);
	abb_destruir(abb);
	print_test("Se destruyo un abb con elementos pero sin funcion para destruirlos", true);
}

static void prueba_destruir_vacio_con_funcion(){
	//Destruyo uno sin elementos pero con funcion para destruir los elementos
	abb_t* abb = abb_crear(comparar_enteros, free);
	abb_destruir(abb);
	print_test("Se destruyo un abb sin elementos pero con funcion para destruirlos", true);
}

static void prueba_destruir_no_vacio_con_funcion(){
	//Destruyo uno con elementos y con funcion para destruirlos.
	//Uso memoria dinamica => le paso "free()" como funcion
	//de destruccion de datos.

	bool guardado = true;

	int* arreglo[10];

	for (int i = 0; i < 10; i++){
		arreglo[i] = malloc(sizeof(int));
	}

	abb_t* abb = abb_crear(comparar_enteros, free);
	char str[3];

	for(int i = 0; i < 10; i++){
		sprintf(str, "%d", i);
		guardado &= abb_guardar(abb, str, arreglo[i]);
	}
	print_test("Se pudieron guardar 10 elementos", guardado);
	abb_destruir(abb);
	print_test("Se destruyo un abb con elementos y con funcion para destruirlos", true);
}


bool sumar(const char* clave, void* valor, void* extra){
	*(int*) extra += *(int*) valor;
	return true;
}

static void prueba_iterador_interno(){
	abb_t* abb = abb_crear(comparar_enteros, NULL);

	int valor = 1;
	int sumatoria = 0;

	bool guardado = true;
	bool cantidad = true;
	char str[3];

	for (int i = 0; i < 20; i++){
		sprintf(str, "%d", i);
		guardado &= abb_guardar(abb, str, &valor);
		cantidad &= abb_cantidad(abb) == i + 1;
	}

	print_test("Se puedieron guardar 20 elementos", guardado);
	print_test("La cantidad dio bien siempre", cantidad);

	abb_in_order(abb, sumar, &sumatoria);

	print_test("La sumatoria dio lo que se esperaba", sumatoria == 20);

	abb_destruir(abb);
}

static void prueba_iterador_externo(){
	abb_t* abb = abb_crear(comparar_enteros, NULL);

	int valor = 1;

	print_test("Se guardo la clave 10", abb_guardar(abb, "10", &valor));
	print_test("Se guardo la clave 8", abb_guardar(abb, "8", &valor));
	print_test("Se guardo la clave 13", abb_guardar(abb, "13", &valor));
	print_test("Se guardo la clave 5", abb_guardar(abb, "5", &valor));
	print_test("Se guardo la clave 9", abb_guardar(abb, "9", &valor));
	print_test("Se guardo la clave 12", abb_guardar(abb, "12", &valor));
	print_test("Se guardo la clave 14", abb_guardar(abb, "14", &valor));

	//El in-order del abb seria [5, 8, 9, 10, 12, 13, 14]

	abb_iter_t* iter = abb_iter_in_crear(abb);

	print_test("Se creo el iterador", iter != NULL);
	print_test("El iterador no esta al final", !abb_iter_in_al_final(iter));
	print_test("Al ver actual recibo 5", strcmp(abb_iter_in_ver_actual(iter), "5") == 0);
	print_test("El iterador pudo avanzar", abb_iter_in_avanzar(iter));
	print_test("El iterador no esta al final", !abb_iter_in_al_final(iter));
	print_test("Al ver actual recibo 8", strcmp(abb_iter_in_ver_actual(iter), "8") == 0);
	print_test("El iterador pudo avanzar", abb_iter_in_avanzar(iter));
	print_test("El iterador no esta al final", !abb_iter_in_al_final(iter));
	print_test("Al ver actual recibo 9", strcmp(abb_iter_in_ver_actual(iter), "9") == 0);
	print_test("El iterador pudo avanzar", abb_iter_in_avanzar(iter));
	print_test("El iterador no esta al final", !abb_iter_in_al_final(iter));
	print_test("Al ver actual recibo 10", strcmp(abb_iter_in_ver_actual(iter), "10") == 0);
	print_test("El iterador pudo avanzar", abb_iter_in_avanzar(iter));
	print_test("El iterador no esta al final", !abb_iter_in_al_final(iter));
	print_test("Al ver actual recibo 12", strcmp(abb_iter_in_ver_actual(iter), "12") == 0);
	print_test("El iterador pudo avanzar", abb_iter_in_avanzar(iter));
	print_test("El iterador no esta al final", !abb_iter_in_al_final(iter));
	print_test("Al ver actual recibo 13", strcmp(abb_iter_in_ver_actual(iter), "13") == 0);
	print_test("El iterador pudo avanzar", abb_iter_in_avanzar(iter));
	print_test("El iterador no esta al final", !abb_iter_in_al_final(iter));
	print_test("Al ver actual recibo 14", strcmp(abb_iter_in_ver_actual(iter), "14") == 0);
	print_test("El iterador no pudo avanzar", !abb_iter_in_avanzar(iter));
	print_test("El iterador esta al final", abb_iter_in_al_final(iter));
	print_test("Al intentar ver actual recibo NULL", abb_iter_in_ver_actual(iter) == NULL);

	abb_iter_in_destruir(iter);
	abb_destruir(abb);
}

void pruebas_lista_estudiante(void){
	prueba_abb_vacio();
	prueba_unico_elem();
	prueba_abb_guardar();
	prueba_abb_reemplazar();
	prueba_abb_reemplazar_con_destruir_dato();
	prueba_abb_valor_NULL();
	prueba_destruir_vacio_sin_funcion();
	prueba_destruir_no_vacio_sin_funcion();
	prueba_destruir_vacio_con_funcion();
	prueba_destruir_no_vacio_con_funcion();
	prueba_iterador_interno();
	prueba_iterador_externo();
}


#ifndef CORRECTOR  // Para que no dé conflicto con el main() del corrector.

int main(void) {
	pruebas_lista_estudiante();
	return failure_count() > 0;  // Indica si falló alguna prueba.
}

#endif
