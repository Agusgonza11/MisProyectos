#para solo recorrer
def _dfs(grafo, v, visitados):
	visitados.append(v)
	for w in grafo.obtener_adyacentes(v):
		if w not in visitados:
			_dfs(grafo, w, visitados)



#Calcular grafos grafos dirigidos O(V + E)
def calcular_grados(grafo):
	gr_entrada = {}
	gr_salida = {}
	for v in grafo.obtener_vertices():
		gr_salida[v] = 0
		gr_entrada[v] = 0
	for v in grafo.obtener_vertices():
		for w in grafo.obtener_adyacentes(v):
			gr_salida[v] += 1
			gr_entrada[w] += 1
	return gr_entrada, gr_salida
	
	
	
#Hacer una cosa luego otra, lista de tareas O(V + E)
def orden_topologico(grafo):
	g_entrada = calcular_grados_entrada(grafo)
	c = Cola()
	for v in grafo.obtener_vertices():
		if g_entrada[v] == 0:
			c.encolar(v)
	resultado = []
	while not c.esta_vacia():
		v = c.desencolar()
		resultado.append(v)
		for w in grafo.obtener_adyacentes(v):
			g_entrada[w] -= 1
			if g_entrada[w] == 0:
				c.encolar(w)
	return resultado
	
	

#BFS grafo no dirigido O(V + E)
def bfs(grafo, origen):
	visitados = set()
	padres = {}
	orden = {}
	padres[origen] = None
	orden[origen] = 0
	visitados.add(origen)
	c = Cola()
	c.encolar(origen)
	while not c.esta_vacia():
		v = c.desencolar()
		for w in grafo.adyacentes(v):
			if w not in visitados:
				padres[w] = v
				orden[w] = orden[v] + 1
				visitados.add(w)
				c.encolar(w)
	return padres,orden #o lo que haga falta
	
#DFS grafo no dirigido O(V + E)
def _dfs(grafo, v, visitados, padres, orden):
	for w in grafo.adyacentes(v):
		if w not in visitados:
			visitados.add(w)
			padres[w] = v
			orden[w] = orden[v] + 1
			_dfs(grafo, w, visitados, padres, orden)
			
			
def dfs(grafo, origen):
	padres = {}
	orden = {}
	visitados = set()
	padres[origen] = None
	orden[origen] = 0
	visitados.add(origen)
	_dfs(grafo, origen, visitados, padres, orden)
	return padres, orden #o lo que haga falta
	
	
#esta es para el caso de un grafo que no es conexo
def recorrido_dfs_completo(grafo):
	visitados = set()
	padres = {}
	orden = {}
	for v in grafo.obtener_vertices():
		if v not in visitados:
			visitados.add(v)
			padres[v] = None
			orden[v] = 0
			_dfs(grafo, v, visitados, padres, orden)
	return padres, orden
	
	
#un vertice es un punto de articulacion de un grafo no dirigido, si eliminar dicho vertice 
#implicaria desconectar el grafico
def puntos_art(grafo, v, visitados, es_raiz, orden, mas_bajo, p_art):
	visitados.add(v)
	hijos = 0
	for w in grafo.obtener_adyacentes(v):
		if w not in visitados:
			orden[w] = orden[v] + 1
			hijos += 1
			puntos_art(grafo, w, visitados, False, orden, mas_bajo, p_art)
			if mas_bajo[w] >= orden[v] and es_raiz==False:
				p_art.add(v)
			mas_bajo[v] = min(mas_bajo[v], mas_bajo[w])
		else:
			mas_bajo[v] = min(mas_bajo[v], orden[w])
	if es_raiz and hijos > 1:
		p_art.add(v)
		
#componente fuertemente conexa para grafos dirigidos
def cfc(grafo, v, visitados, pila, apilados, orden, mb, cfcs, *indice):
	visitados.add(v)
	pila.apilar(v)
	apilados.add(v)
	mb[v] = orden[v]
	for w in grafo.obtener_adyacentes(v):
		if w not in visitados:
			orden[w] = *indice + 1
			*indice++
			cfc(grafo, w, visitados, pila, apilados, orden, mb, cfcs, indice)
			mb[v] = min(mas_bajo[v], mas_bajo[w])
		else if w in apilados:
			mb[v] = min(mb[v], orden[w])
	if mb[v] == orden[v]:
		nueva_cfc = []
		while True:
			w = pila.desapilar()
			apilados.remove(w)
			nueva_cfc.append(w)
			if w == v:
				break
		cfcs.append(nueva_cfc)
		
		
#para ver si un grafo es bipartito
def bipartito(grafo):
	color = {}
	for v in grafo.vertices:
		color[v] = None
	nodoRandom = grafo.vertice_aleatorio():
	color[nodoRandom] = True
	cola = Cola()
	cola.encolar(nodoRandom)
	while not cola.esta_vacia():
		v = cola.desencolar()
		for w in grafo.obtener_adyacentes(v):
			if color[v] == color[w]:
				return False
			if color[w] == NULL:
				if color[v] == True:
					color[w] = False
				else:
					color[w] = True
				cola.encolar(w)
	return True
		
		
		
		
		
		

	
	
	
	
	
	
	
	
	
	
	

