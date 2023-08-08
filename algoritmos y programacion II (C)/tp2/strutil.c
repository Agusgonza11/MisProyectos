#define _POSIX_C_SOURCE 200809L
#include "strutil.h"
#include <stdlib.h>
#include <string.h>

char *substr(const char *str, size_t n){
	char* cadena_nueva = malloc(sizeof(char*) * n + 1);
	if(!cadena_nueva) return NULL;
	cadena_nueva = strncpy(cadena_nueva, str, n);
	cadena_nueva[n] = '\0';
	return cadena_nueva;
}
char **split(const char *str, char sep){
	size_t largo = strlen(str);
	size_t largo_vector = 0;
	for(size_t i = 0; i<largo; i++){
		if(str[i]==sep){
			largo_vector++;
		}
	}
	char** vector = malloc(sizeof(char*) * (largo_vector+2));
	if(!vector) return NULL;
	size_t contador_vector = 0;
	size_t ultimo_sep = 0;
	for(size_t i = 0; i<=largo; i++){
		if(str[i]==sep || i==largo){
			if(contador_vector==0){
				vector[contador_vector] = substr(str, i);
				contador_vector++;
				ultimo_sep = i + 1;
				continue;
			}
			vector[contador_vector] = substr(str + ultimo_sep, i - ultimo_sep);
			contador_vector++;
			if(i==largo){
				break;
			}
			ultimo_sep = i + 1;
		} 
	}
	vector[contador_vector] = NULL;
	return vector;
}



char *join(char **strv, char sep){
	size_t largo_total = 0;
	size_t cant_sep = 0;
	for(size_t i = 0; strv[i]!=NULL ; i++){
		largo_total += strlen(strv[i]);
		cant_sep = i + 1;
	}
	largo_total += cant_sep;
	if(strv[0]==NULL){
		char* cadena = malloc(sizeof(char) * 2);
		if(!cadena) return NULL;
		cadena[0] = '\0';
		return cadena;
	}
	char* cadena = calloc(largo_total, sizeof(char));
	if(!cadena) return NULL;
	char separador[] = {sep,'\0'};
	size_t contador = 0;
	for(size_t i = 0; strv[i]!=NULL ; i++){
		strcat(cadena+contador, strv[i]);
		if(strv[i+1]==NULL){
			break;
		}
		size_t largo = strlen(strv[i]);
		contador += largo;
		strcat(cadena+contador, separador);
	}
	return cadena;
}




void free_strv(char *strv[]){
	for(size_t i = 0; strv[i]!=NULL; i++){
		free(strv[i]);
	}
	free(strv);
}











