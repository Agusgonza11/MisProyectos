#include <stdio.h>


int desordenado(int arreglo[],size_t inicio,  size_t fin){
	if(inicio>fin){
		return -1;
	}
	size_t medio = (inicio + fin) / 2;
	if(arreglo[medio-1]>arreglo[medio]){
		return arreglo[medio];
	}
	size_t contador = 0;
	for(int i=0;i<medio;i++){
		if(arreglo[i]<arreglo[i+1]){
			contador++;
		}
	}
	if(contador==medio){
		return desordenado(arreglo, medio + 1, fin);
	}
	else{
		return desordenado(arreglo, inicio, medio-1);
	}
}

int ceros(int arreglo[],size_t inicio,  size_t fin){
	if(inicio>fin){
		return -1;
	}
	if(arreglo[0]==0){
		return 0;
	}
	size_t medio = (inicio + fin) / 2;
	if(arreglo[medio-1]==1 && arreglo[medio]==0){
		return medio;
	}
	if(arreglo[medio] == 1){
		return ceros(arreglo, medio + 1, fin);
	}
	else{
		return ceros(arreglo, inicio, medio-1);
	}
}

size_t raiz(size_t numero, size_t inicio, size_t fin){
	size_t medio = (inicio + fin) /2;
	size_t cuadrado = medio*medio;
	if(cuadrado <= numero && (medio+1)*(medio+1) > numero){
		return medio;
	}
	if (cuadrado>numero){
		return raiz(numero, inicio, medio);
	}
	return raiz(numero, medio, fin);
}

size_t posicion_pico(size_t arreglo[], size_t inicio, size_t fin){
	size_t medio = (inicio+fin)/2;
	if(inicio>fin){
		return -1;
	}
	if(arreglo[medio-1] < arreglo[medio] && arreglo[medio] > arreglo[medio+1]){
		return medio;
	}
	size_t contador = 0;
	for(int i=0; i<medio; i++){
		if(arreglo[medio-1]<arreglo[medio]){
			contador++;
		}
	}
	if(contador==medio){
		return posicion_pico(arreglo, medio+1, fin);
	}
	else{
		return posicion_pico(arreglo, inicio, medio-1);
	}
}

int _mas_cercano(int arreglo[], size_t inicio, size_t fin, int n){
	size_t medio = (inicio + fin) / 2;
	if(inicio == fin){
		return arreglo[medio];
	}
	if(arreglo[medio] < n){
		return _mas_cercano(arreglo, medio + 1, fin, n);
	}
	if(arreglo[medio] > n){
		return _mas_cercano(arreglo, inicio, medio -1, n); 
	}
	return arreglo[medio];
}

int mas_cercano(int arreglo[], size_t largo, int n){
	int resultado = _mas_cercano(arreglo, 0, largo-1, n);
	return resultado;
}

int main(){
	int arreglo[] = {1,2,3,4,7};
	size_t largo = 5;
	int elemento = 0;
	printf("%d\n", mas_cercano(arreglo, largo, elemento));
	return 0;
}
