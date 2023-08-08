#include "pila.h"
#include "dc.h"
#include "strutil.h"
#include "calc_helper.h"
#include <string.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>


bool operacion(calc_num primero, calc_num segundo, calc_num tercero, calc_operador operador, calc_num* resultado){
	if(operador.num_operandos==1){
		if(primero<0){
			return false;		
		}
		double parcial;
		parcial = sqrt((double)primero);
		*resultado =  (calc_num)parcial;	
	}
	if(operador.num_operandos==3){
		*resultado = tercero ? segundo : primero;
	}
	if(operador.num_operandos==2){
		if(operador.op == OP_ADD){
			*resultado = segundo + primero;
		}
		if(operador.op == OP_SUB){
			*resultado = segundo - primero;
		}
		if(operador.op == OP_MUL){
			*resultado = segundo * primero;
		}
		if(operador.op == OP_DIV){
			if(primero==0){
				return false;		
			}
			*resultado = segundo / primero;
		}
		if(operador.op == OP_POW){
			if(primero<0){
				return false;		
			}
			double parcial_1;
			double parcial_2;
			double resultado_parcial;
			parcial_1 = (double)primero;
			parcial_2 = (double)segundo;
			resultado_parcial = pow(parcial_2, parcial_1);
			*resultado = (calc_num)resultado_parcial;
		}
		if(operador.op == OP_LOG){
			if(primero<2){
				return false;	
			}
			double parcial_1;
			double parcial_2;
			double resultado_parcial;	
			parcial_1 = (double)primero;
			parcial_2 = (double)segundo;
			resultado_parcial = log((parcial_2)) / log((parcial_1));
			*resultado = (calc_num)resultado_parcial;
		}
	}
	return true;	
}


bool dc(char* linea_ingresada, calc_num* resultado){
	char** linea = dc_split(linea_ingresada);	
	int cantidad_num = 0;
	pilanum_t* pila = pilanum_crear();
	for(size_t i = 0; linea[i]!=NULL; i++){
		struct calc_token tipo;
		calc_num primero;
		calc_num segundo;
		calc_num tercero;
		if(calc_parse(linea[i], &tipo)){
			if(tipo.type==TOK_NUM){
				apilar_num(pila, tipo.value);
				cantidad_num++;
				continue;
			}
			else if(cantidad_num < tipo.oper.num_operandos){
				pilanum_destruir(pila);
				free_strv(linea);
				return false;				
			}
			else if(tipo.type==TOK_OPER && tipo.oper.num_operandos==2){
				desapilar_num(pila, &primero);
				desapilar_num(pila, &segundo);
				cantidad_num = cantidad_num - 2;
				if(!operacion(primero, segundo, tercero, tipo.oper, resultado)){
					pilanum_destruir(pila);
					free_strv(linea);
					return false;
				}
			}	
			else if(tipo.type==TOK_OPER && tipo.oper.num_operandos==1){
				desapilar_num(pila, &primero);
				cantidad_num--;
				if(!operacion(primero, segundo, tercero, tipo.oper, resultado)){
					pilanum_destruir(pila);
					free_strv(linea);
					return false;
				}
			}	
			else if(tipo.type==TOK_OPER && tipo.oper.num_operandos==3){
				desapilar_num(pila, &primero);
				desapilar_num(pila, &segundo);
				desapilar_num(pila, &tercero);
				cantidad_num = cantidad_num - 3;
				if(!operacion(primero, segundo, tercero, tipo.oper, resultado)){
					pilanum_destruir(pila);
					free_strv(linea);
					return false;
				}
			}	
			apilar_num(pila, *resultado);
			cantidad_num++;
		}
		else{
			pilanum_destruir(pila);
			free_strv(linea);
			return false;
		}
	}
	if(cantidad_num>1){
		pilanum_destruir(pila);
		free_strv(linea);
		return false;
	}
	pilanum_destruir(pila);
	free_strv(linea);
	return true;
}

int main(void){

	char* buffer = NULL;
	size_t capacidad = 0;
	while(getline(&buffer, &capacidad, stdin)>0){
		if(buffer[0]=='\n') break;
		calc_num resultado;
		if(dc(buffer, &resultado)){
		   	printf("%ld\n", resultado); 
		}
		else{
		   	fprintf(stdout, "ERROR\n");
		}
	}
	free(buffer);
	return 0;
}
