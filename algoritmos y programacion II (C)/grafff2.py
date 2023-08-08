#Bellman-ford
#Grafo dirigido y pesos negativos
def	camino_minimo_bd(grafo, origen): #O(V x E)
	distancia = {}
	padre = {}
	for v in grafo:
		distancia[v] = float("inf")
	distancia[origen] = 0
	padre[origen] = None
	aristas = obtener_aristas(grafo) #O(V + E)
	for i in range(len(grafo)): #itero V veces
		for v, w, peso in aristas: #y aca veo todas las aristas, por lo tanto se vuelve O(VxE)
			if distancia[v] + peso < distancia[w]:
				padre[w] = v
				distancia[w] = distancia[v] + peso
				
	for v, w, peso in aristas:
		if distancia[v] + peso < distancia[w]:
			return None #Por si hay un ciclo negativo
	return padre, distancia
	
def obtener_aristas(grafo):
	aristas = []
	for v in grafo:
		for w in grafo.adyacentes(v):
			aristas.append((v, w, grafo.peso(v, w)))
	return aristas
	
	
#Codigo Dijkstra camino minimo regular, si hay ciclo negativo algoritmo bellman-ford
def camino_minimo_dijkstra(grafo, origen): #O(E log V)
	dist = {}
	padre = {}
	for v in grafo:
		dist[v] = float("inf")
	dist[origen] = 0
	padre[origen] = None
	q = Heap()
	q.encolar((0, origen))
	while not q.esta_vacio():
		_, v = q.desencolar()
		for w in grafo.adyacentes(v):
			if dist[v] + grafo.peso(v, w) < dist[w]:
				dist[w] = dist[v] + grafo.peso(v, w)
				padre[w] = v
				q.encolar((dist[w], w))
	return padre, dist


#no sirve para grafos dirigidos
#Algoritmo para arboles de tendido minimo, es conectar todos los vertices con la menor cantidad
#de peso total posible. Si prim tiene mas de una componente conexa lo que pasa es que
#solo va a generar el arbol respecto a la componente conexa en la que se encuentra el vertice aleatorio, lo podria solucionar haciendo prim sobre los vertices no visitados
def mst_prim(grafo): #O(E log V)
	g = Grafo()
	h = Heap()
	visitados = set()
	for v in grafo.obtener_vertices():
		g.agregar_vertice(v)
	v = grafo.vertice_aleatorio()
	visitados.add(v)
	for w in grafo.adyacentes(v):
		h.encolar(v, w, grafo.peso_arista(v,w))
	while not h.esta_vacio():
		v, w, peso = h.desencolar()
		if w in visitados:
			continue
		g.agregar_arista(v, w, peso)
		visitados.add(w)
		for a in grafo.adyacentes(w):
			if a not in visitados:
				h.encolar(w, a, grafo.peso_arista(w,a))	
	return g
	
#Algoritmo para arboles de tendido minimo, es conectar todos los vertices con la menor cantidad
#de peso total posible. Sirve en el caso de tener varias componentes conexas
def mst_kruskal(grafo): #O(E log V)
	conjuntos = UnionFind(grafo.obtener_vertices())
	aristas = sorted(obtener_aristas(grafo), key=lambda arista: arista[2])
	g = Grafo()
	for v in grafo.obtener_vertices():
		g.agregar_vertice(v)
	for a in aristas:
		v, w, peso = a
		if conjuntos.find(v) == conjuntos.find(w):
			continue
		g.agregar_arista(v, w, peso)
		conjuntos.union(v, w)
	return g




#Backtracking, la complejidad es exponencial porque probas todas las posibilidades
def camino_hamiltoniano_dfs(grafo, v, visitados, camino):
	visitados.add(v)
	camino.append(v)
	if len(visitados) == len(grafo):
		return True
	for w in grafo.adyacentes(v):
		if w not in visitados:
			if camino_hamiltoniano_dfs(grafo,  w, visitados, camino):
				return True
	visitados.remove(v)
	camino.pop()
	return False
	
def camino_hamiltoniano(grafo):
	camino = []
	visitados = set()
	for v in grafo:
		if camino_hamiltoniano_dfs(grafo, v, visitados, camino):
			return camino
	return None


#ejercicio coloreo de paises por backtracking, la complejidad es O(m elevado p) p paises y m colores
def coloreo(mapa, pais, coloreados, colores):
	if(len(coloreados) == len(mapa)):#1)Caso base, si esta todo coloreado devuelvo True
		return True
	p = pais + 1
	for c in colores:	
		coloreados[p] = c #2)Se hace algo, se colorea con un color el siguiente pais
		if not es_valido(mapa, p, coloreados):#3) Verifico si essolucion parcial
			coloreados.remove(p)   #a)Si no lo es, etrocedo y vuelvo a 2)
			continue
		if coloreo(mapa, p, coloreados, colores):#b)Si lo es, llamo recursivamente y vuelvo a 1)
			return True
	coloreados.remove(p) #4)Si ya probe con todo y no hubo solucion, retrocedo
	return False
	
def es_valido(mapa, pais, coloreados):
	for p in mapa.adyacentes(pais):
		if p in coloreados and coloreados[p] == coloreados[pais]:
			return False
	return True

def _camino(grafo, actual, destino, distancia, visitados):
	if(actual == destino):
		return True
	for w in grafo.adyacentes(actual):
		act = w
		visitados.add(act)
		distancia[t] +=1
		if act in visitados:
			distancia[t] -= 1
			continue			
		if _camino(grafo, act, destino, distancia, visitados):
			return True
	return False

def camino(grafo, s, t):
	distancia = {}
	visitados = set()
	visitados.add(s)
	distancia[t] = 0
	_camino(grafo, s, t, distancia, visitados)
	return distancia[t]

#Redes de flujo
#el corte minimo es igual al flujo maximo
def flujo(grafo, s, t): #O(V * Eal cuadrado)
	flujo = {}
	for v in grafo:
		for w in grafo.adyacentes(v):
			flujo[(v, w)] = 0
	grafo_residual = copiar(grafo)
	while camino = obtener_camino(grafo_residual, s, t) is not None:
		capacidad_residual_camino = min_peso(grafo, camino)
		for i in range(1, len(camino)):
			if camino[i] in grafo.adyacentes(camino[i-1]):
				flujo[(camino[i-1], camino[i])] += camino residual_camino
				actulizar_grafo_residual(grafo_residual, camino[i-1], camino[i], capacidad_residual_camino)
			else:
				flujo[(camino[i], camino[i-1])] -= camino residual_camino
				actulizar_grafo_residual(grafo_residual, camino[i], camino[i-1], capacidad_residual_camino)
	return flujo

def actualizar_grafo_residual(grafo_residual, u, v, valor):
	peso_anterior = grafo_residual.peso(u,v)
	if peso_anterior == valor:
		grafo_residual.remover_arista(u,v)
	else:
		grafo_residual.cambiar_peso(u, v, peso_anterior - valor)
	if not grafo_residual.son_adyacentes(v,u):
		grafo_residual.agregar_arista(v,u,valor)
	else:
		grafo_residual.cambiar_peso(v, u, peso_anterior + valor)


















