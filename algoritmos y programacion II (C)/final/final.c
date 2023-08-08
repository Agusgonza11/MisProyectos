EJERCICIO 1)
def _dfs(grafo, visitados, u, v, contador):
	visitados.append(u)
	for w in grafo.obtener_adyacentes(u):
		if w not in visitados:
			_dfs(grafo, visitados, w, v, contador)
		if w == v:
			contador++


def caminos(grafo, u, v):
	visitados = set()
	contador = 0
	_dfs(grafo, visitados, u, v)
	return contador
	
#La complejidad del algoritmo sera O(V + E) ya que se recorren todos los vertices y sus aristas
en un tipico caso de dfs


EJERCICIO 2)
a) 
int ab_propagar_suma(ab_nodo_t* actual){
	if(actual == NULL) return; //O(1)
	if(actual->izq==NULL && actual->der==NULL) return actual->dato; //O(1)
	int num1= _ab_propagar_suma(actual->izq); 
	int num2= _ab_propagar_suma(actual->der); 
	actual->dato = num1 + num2; //O(1)
	return actual->dato; //O(1)
}

void ab_propagar_suma(ab_t*){
	_ab_propagar_suma(ab_t->raiz);
}
//La complejidad de esta primitiva sera O(n) ya que recorro todos los nodos
b)



EJERCICIO 3)
def mejores_jugadores(jugadores):
	aux = {} #O(1)
	puntajes = [] #O(1)
	resultado = [] #O(1)
	for jugador in jugadores: #O(n)
		puntaje = obtener_puntaje(jugador) #O(1)
		aux[puntaje] = jugador #O(1)
		puntajes.append(puntaje) #O(1)
	
	h = heap_crear_arr(puntajes, len(jugadores), cmp) #Heap de maximos, una cmp que compara los dos enteros (asumo que obtener_puntaje da enteros), y como a fin de cuentas lo que hace es heapafy es O(n)
	for i in range(10): #O(k)
		if h.esta_vacio() break #O(1)
		puntaje_max = h.desencolar() #O(log n)
		jugador_max = aux[maximo] #O(1)
		resultado.append(jugador_max) #O(1)
		
	return resultado
#La complejidad del algoritmo sera de O(1) + O(n) + O(k log n) donde k es igual a 10 o en caso de haber menos cantidad de jugadores sera igual a la cantidad de jugadores
En total la complejidad es O(n + k log n)


	
EJERCICIO 4)
int _raiz(int (*f)(int), int inicio, int fin){
	int medio = (inicio + fin)/2; 
	int resultado = f(medio);
	if(resultado == 0) return medio;
	if(resultado > 0 && f(inicio) > f(fin)) return _raiz(*f, medio+1, fin);
	if(resultado < 0 && f(inicio) < f(fin)) return _raiz(*f, medio+1, fin);
	if(resultado > 0 && f(inicio) < f(fin)) return _raiz(*f, inicio, medio-1);
	if(resultado < 0 && f(inicio) > f(fin)) return _raiz(*f, inicio, medio-1);
	//Se que pude haber puesto todas estos if en dos en vez de en cuatro pero me parecio que 
	//asi quedaba mas prolijo a la vista	

}
int raiz(int (*f)(int), int a, int b){
	if ((f(a) > 0 && f(b) < 0) || (f(a) < 0 && f(b) > 0)){ //Esto no sabia si era necesario, pero comprobe que se cumpla la propiedad de que en a es positiva y b negativa o viceversa
		return _raiz(*f, a, b);
	}
}
//La complejidad sera O(log n), ya que por el teorema maestro b=2 (divido el arreglo en dos mitades)
//a = 1 (solo entro en una de esas mitades) y c=0 (ya que todas las otras operaciones son de O(1)
	
	
EJERCICIO 5)
A) Si solo devuelve valores entre 0 y 10 es una funcion de hashing muy mala, y cuando en
hopscotch hashing se tiene una mala funcion de hashing, sucede que las busquedas se 
convierten en O(n) ya que se estaria redimensionando constantemente

B) En cuckoo hashing se redimensiona cuando se llega a un loop, por ejemplo:
	posiciones = 0,1,2,3,4
	personas = juan, pedro, agustin
	hash1(juan) = 1       hash2(juan) = 3
	hash1(pedro) = 3      hash2(pedro) = 1
	hash1(agustin) = 3    hash2(agustin) = 1
	
	0: , 1: juan, 2: , 3: pedro, 4: 
	
	Ahora tendria que insertar a agustin, pero como la posicion 3 ya esta ocupada por pedro
	quedaria asi
	
	0: , 1: juan, 2: , 3: agustin, 4: 
	
	El problema es que ahora hay que ubicar a pedro, asi que vamos a su segunda alternativa que
	es 1 y a juan lo llevamos a su segunda, que es 3
	
	0: , 1: pedro, 2: , 3: juan, 4: 
	
	Pero nuevamente tenemos que ubicar a agustin, asi que vamos a su segunda alternativa, esta es 1 y
	ya esta ocupada por pedro, vamos a su siguiente alternativa que es 1, pero esta tambien esta ocupada,
	y al estar ocupada, y ser la alternativa original, se puede decir que entro en un loop, por lo tanto se redimensiona
	
	
	
	
