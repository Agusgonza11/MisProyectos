#ifndef INFIX_H
#define INFIX_H

#include <stddef.h>
#include <stdbool.h>
#include "pila.h"
#include "cola.h"
#include "calc_helper.h"
#include "strutil.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>


//Recibe una cadena de caracteres que ingresa el usuario de tipo notacion infija y devuelve la misma cadena transformada en notacion posfija
char* infix(char* linea_ingresada);

#endif 
