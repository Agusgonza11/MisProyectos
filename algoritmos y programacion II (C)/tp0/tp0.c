
#ifndef TP0_H
#define TP0_H


void swap(int *x, int *y) {
	int variable_x = *x;
	*x = *y;
	*y = variable_x;
}


int maximo(int vector[], int n) {
	if(n==0){
		return -1;
	}	
	int maximo_local = vector[0];
	int posicion_maximo = 0;
	for(int i=1; i<n; i++){
		if(maximo_local < vector[i]){
			posicion_maximo = i;
			maximo_local = vector[i];
		}
	}
	return posicion_maximo;
}



int comparar(int vector1[], int n1, int vector2[], int n2) {
    for(int i = 0; i < n1 && i < n2 ; i++){
    	if(vector1[i] < vector2[i]){
    		return -1;
    	}
    	if(vector1[i] > vector2[i]){
    		return 1;
    	}
    }
    if(n1 > n2){
        return 1;
    }
    if(n2 > n1){
        return -1;
    }
    return 0;
}



void seleccion(int vector[], int n) {
	for(int i=n-1; i>=0 ; i--){
        int indice_maximo_actual = maximo(vector, i+1);
        swap(&vector[indice_maximo_actual], &vector[i]);
	}
}


#endif  // TP0_H

