//padron 106086
//ejercicio 1 (1)
int _mas_cercano(int arreglo[], size_t inicio, size_t fin, int n){
	size_t medio = (inicio + fin) / 2; //O(1)
	if(inicio == fin){ //O(1)
		return arreglo[medio]; //O(1)
	}
	if(arreglo[medio] < n){ //O(1)
		return _mas_cercano(arreglo, medio + 1, fin, n); //Parto en dos mitades, pero solo se va a llamar a una
	}
	if(arreglo[medio] > n){ //O(1)
		return _mas_cercano(arreglo, inicio, medio -1, n); //Parto en dos mitades, pero solo se va a llamar a una
	}
	return arreglo[medio]; //O(1)
}

int mas_cercano(int arreglo[], size_t largo, int n){
	int resultado = _mas_cercano(arreglo, 0, largo-1, n); //O(1)
	return resultado; //O(1)
}
//divido el algoritmo en dos mitades, por lo tanto B = 2. Pero utilizamos solo una de las dos mitades, por lo tanto A = 1. Todo el resto de las operaciones son de tiempo constante por lo tanto C = 0. Por lo tanto por el teorema maestro esto tiene una complejidad de O(log n)




//ejercicio 2 (5)
int* merge_colas(cola* cola_1, cola* cola_2){
	int* vector = malloc(sizeof(int*)); //O(1)
	pila_t* pila_aux = pila_crear();  //O(1)
	while(!cola_esta_vacia(cola_1) && !cola_esta_vacia(cola_2)){ //si bien es cierto que todas las operaciones dentro del while son de tiempo constante, se repiten n o m veces (dependiendo de cual de estos es mayor) por lo tanto se puede decir que la complejidad de esta parte es O(max entre(n y m))
		if(cola_ver_primero(cola_1) < cola_ver_primero(cola_2)){ //O(1)
			int elemento = cola_desencolar(cola_1); //O(1)
			if(elemento != pila_ver_tope(pila_aux)){ //O(1)
				pila_apilar(pila_aux, elemento); //O(1)
			}
		}
		if(cola_ver_primero(cola_1) > cola_ver_primero(cola_2)){ //O(1)
			int elemento = cola_desencolar(cola_2); //O(1)
			if(elemento != pila_ver_tope(pila_aux)){ //O(1)
				pila_apilar(pila_aux, elemento); //O(1)
			}
		}
		if(cola_ver_primero(cola_1) == cola_ver_primero(cola_2)){ //O(1)
			int elemento = cola_desencolar(cola_1); //O(1)
			pila_apilar(pila_aux, elemento); //O(1)
			cola_desencolar(cola_2); //O(1)
		}	
	}
	cola_destruir(cola_1, NULL); //O(n)
	cola_destruir(cola_2, NULL); //O(m)
	size_t contador = 0; //O(1)
	while(!pila_esta_vacia(pila_aux)){ //O(max entre(n y m)
		int elemento = pila_desapilar(pila_aux); //O(1)
		vector[contador] = elemento; //O(1)
		contador++; //O(1)
	}
	pila_destruir(pila_aux); //O(1)
	return vector; //O(1)
}
//La complejidad sera O(max entre(n y m) + O(max entre(n y m) + O(1) + O(n) + O(m). Se puede decir que la complejidad final del algoritmo sera de O(n*m)





//ejercicio 3 (9)
lista_t* top_3(lista_t* lista){
	lista_iter_t* iter =  lista_iter_crear(lista); //O(1)
	lista_t* resultado = lista_crear(); //O(1)
	while(!lista_iter_al_final(iter) || lista_largo(resultado) == 3){ //La comparacion se realiza un total de n veces por lo tanto O(n)
		lista_iter_t* iter_2 = lista_iter_crear(lista); //O(1)
		while(!lista_iter_al_final(iter_2)){ //La comparacion se realiza un total de n veces por lo tanto O(m)
			int maximo_actual = lista_iter_ver_actual(iter_2); //O(1)
			if(maximo_actual < lista_iter_ver_actual(iter_2) && lista_ver_primero(resultado) != maximo_actual && lista_ver_ultimo(resultado) != maximo_actual ){ //O(1)
				int maximo_actual = lista_iter_ver_actual(iter_2); //O(1)
			}
			lista_iter_avanzar(iter_2); //O(1)
		}
		lista_iter_destruir(iter_2); //O(1)
		if(lista_ver_primero(resultado) != maximo_actual && lista_ver_ultimo(resultado) != maximo_actual){ //O(1)
			lista_insertar_primero(resultado, maximo_actual); //O(1)
		}
	
		lista_iter_avanzar(iter); //O(1)
	}
	lista_iter_destruir(iter); //O(1)
	return resultado;//O(1)
} 
//La complejidad final de este algoritmo es O(n elevado-> m)



















