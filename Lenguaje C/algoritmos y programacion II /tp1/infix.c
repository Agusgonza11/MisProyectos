#include "pila.h"
#include "cola.h"
#include "infix.h"
#include "calc_helper.h"
#include "strutil.h"
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>


char* infix(char* linea_ingresada){
	char** linea = infix_split(linea_ingresada);
	if(!linea){
		free(linea);
		return strdup("");
	}	
	cola_t* cola = cola_crear();
	pila_t* pila = pila_crear();
	if(!cola || !pila){
			free(linea);
			pila_destruir(pila);
			cola_destruir(cola,NULL);
			return strdup("");
	}
	for(size_t i = 0; linea[i]!=NULL ; i++){
		struct calc_token tipo;
		if(calc_parse(linea[i], &tipo)){
			if(tipo.type==TOK_NUM){
				cola_encolar(cola, linea[i]);
			}
			else if(tipo.type==TOK_OPER){
				struct calc_token tope;
			    while(!pila_esta_vacia(pila) && calc_parse(pila_ver_tope(pila), &tope) && tope.type==TOK_OPER && tipo.oper.as==AS_IZQ && tipo.oper.precedencia<=tope.oper.precedencia){
						cola_encolar(cola, pila_desapilar(pila));
				}
				pila_apilar(pila, linea[i]);
				
			}
			else if(tipo.type==TOK_LPAREN){
				pila_apilar(pila, linea[i]);
			}
			else if(tipo.type==TOK_RPAREN){
				struct calc_token tope;
			    while(!pila_esta_vacia(pila) && calc_parse(pila_ver_tope(pila), &tope) && tope.type!=TOK_LPAREN){
						cola_encolar(cola, pila_desapilar(pila));		
			        }
				if(pila_esta_vacia(pila)){
					free(linea);
					pila_destruir(pila);
					cola_destruir(cola,NULL);
					return strdup("");
				}
				free(pila_desapilar(pila));
				free(linea[i]);
			}
		} else {
			free(linea);
			pila_destruir(pila);
			cola_destruir(cola,NULL);
			return strdup("");
		}
	}
	while(!pila_esta_vacia(pila)){
	    cola_encolar(cola, pila_desapilar(pila));
	}
	char** aux = malloc(sizeof(char*) * strlen(linea_ingresada));
	if(!aux){
		free(linea);
		pila_destruir(pila);
		cola_destruir(cola,NULL);
		return strdup("");	
	}
	size_t largo = 0;
	for(size_t i = 0; !cola_esta_vacia(cola); i++){
		char* desencolado = cola_desencolar(cola);
		aux[i] = desencolado;
		largo = i;
	}
	aux[largo+1] = NULL;
	char* resultado = join(aux, ' ');
	free_strv(aux);
	free(linea);
	pila_destruir(pila);
	cola_destruir(cola,NULL);
	return resultado;
}

int main(void){
	char* buffer = NULL;
	size_t capacidad = 0;
	while(getline(&buffer, &capacidad, stdin)>0){
		if(buffer[0]=='\n') break;
		char* notacion_fija = infix(buffer);
		printf("%s\n", notacion_fija); 
		free(notacion_fija);
	}
	free(buffer);
	return 0;
}





