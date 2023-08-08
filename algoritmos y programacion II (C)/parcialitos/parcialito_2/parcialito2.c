//Padron: 106086

//Ejercicio 5
bool aplicar_selectivo(const hash_t* hash, int k, void(*aplicar)(void* dato)){
	if(!hash) return false;
	int contador = 0; //O(1)
	for(int i = 0; i< hash->capacidad; i++){ //O(n) = siendo n el largo de la tabla de hash
		if(contador==k) break; //O(1), pero esta condicion presenta la chance de que la iteracion de mas arriba que es O(n) se vuelva O(k)
		if(hash->tabla[i]==NULL) continue; //O(1)  
		lista_iter_t* iter = lista_iter_crear(hash->tabla[i]); //O(1)
		nodo_t* actual = (nodo_t*) lista_iter_ver_actual(iter); //O(1)
		aplicar(actual->dato); //O(1)
		contador++; //O(1)
		lista_iter_avanzar(iter); //O(1)
	}
	return true;
}
//La complejidad final del algoritmo sera O(n)



//Ejercicio 3
void _ab_sin_hermanos(const ab_t* ab, size_t* contador){
	if(!ab->izq && !ab->der) return; //O(1)
	_ab_sin_hermanos(ab->izq, contador); //T(n/2)
	if(!ab->der || !ab->izq) *contador++; //O(1)
	_ab_sin_hermanos(ab->der, contador); //T(n/2)
	if(!ab->izq || !ab->der) *contador++; //O(1)
} 
//La complejidad de este algoritmos es O(n),A=2, B=2, C=0
size_t ab_sin_hermanos(const ab_t* ab){
	size_t contador = 0; //O(1)
	_ab_sin_hermanos(ab, &contador);  //O(n)
	return contador; //O(1)
}
//O(n)




