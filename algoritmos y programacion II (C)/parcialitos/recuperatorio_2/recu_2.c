//Ejercicio 1
void _abb_mayores(abb, cadena, lista){
	if(!abb) return; //O(1)
	_abb_mayores(abb->izq, cadena, lista); //O(t/2)
	if(abb->strcmp(cadena, abb->clave)>0){ //Este strcmp devuelve 1 si el segundo parametro es mayor que el primero
		lista_insertar_ultimo(lista,(void*) cadena); //Si la clave es mayor a la cadena, inserto en la lista
	}
	_abb_mayores(abb->der, cadena, lista); //O(t/2)
}

lista_t* abb_mayores(const abb_t* abb, const char* cadena){
	lista_t* lista = lista_crear(); //O(1)
	_abb_mayores(abb->raiz, cadena, lista); //O(n)
	return lista; //O(1)
}
//Por division y conquista utilizo el teorema maestro de este obtengo que divido el algoritmo 
//en 2, por lo tanto B=2, A tambien sera igual a 2, ya que de esas dos divisiones, usamos las 
//dos, y C=0 ya que todas las operaciones que hacemos son de tiempo constante.
//La complejidad final sera de O(n).




//Ejercicio 2
hash_t* precios_productos(hash_t* distribuidor_a, hash_t* distribuidor_b){ 
	hash_t* resultado = hash_crear(NULL); //O(1)
	if(!resultado) return NULL;
	hash_iter_t* iter_a = hash_iter_crear(distribuidor_a); //O(1)
	if(!iter_a){
		hash_destruir(resultado);
		return NULL;
	}
	while(!hash_iter_al_final(iter_a)){ //O(n)
		char* producto = hash_iter_ver_actual(iter_a); //O(1)
		void* precio = hash_obtener(distribuidor_a, producto); //O(1)
		hash_guardar(resultado, producto, precio); //O(1)
		hash_iter_avanzar(iter_a); //O(1)
	}
	hash_iter_destruir(iter_a); //O(1)
	hash_iter_t* iter_b = hash_iter_crear(distribuidor_b); //O(1)
	if(!iter_b){
		hash_destruir(resultado);
		return NULL;	
	}
	while(!hash_iter_al_final(iter_b)){ //O(k)
		char* producto = hash_iter_ver_actual(iter_b); //O(1)
		if(hash_pertenece(resultado, producto){ //O(1)
			int precio_a = (int) hash_obtener(resultado, producto); //O(1)
			int precio_b = (int) hash_obtener(distribuidor_b, producto); //O(1)
			if(precio_b<precio_a){ //O(1)
				hash_guardar(resultado, producto, (void*) precio_b); //O(1)
			}
		} else {
			void* precio = hash_obtener(distribuidor_b, producto); //O(1)
			hash_guardar(resultado, producto, precio);		 //O(1)
		}
		hash_iter_avanzar(iter_b);
	}
	hash_iter_destruir(iter_b); //O(1)

	return resultado; //O(1)
}
//La complejidad final sera de O(n) + O(k) + O(1), O(1) es despreciable, entonces la complejidad
//seria O(n + k) siendo n los productos de el distribuidor_a, y k los productos del distribuidor_b
//Es decir que al final de cuentas sera lineal.




















