#ifndef DC_H
#define DC_H

#define _POSIX_C_SOURCE 200809L
#include <stddef.h>


#include <stdbool.h>
#include "pila.h"
#include "calc_helper.h"
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

//Realiza las operaciones dependiendo el operador y los operandos que recibe. Guarda el resultado en resultado y devuelve true.
//En caso de haber algun fallo o de intentar hacer una operacion invalida devuelve false
bool operacion(calc_num primero, calc_num segundo, calc_num tercero, calc_operador operador, calc_num* resultado);


//Recibe una cadena de caractereres en formato calculadora polaca inversa, realiza las operaciones y guarda el resultado en resultado y devuelve true.
//En caso de haber algun fallo o de intentar hacer una operacion invalida devuelve false
bool dc(char* linea_ingresada, calc_num* resultado);

#endif 
