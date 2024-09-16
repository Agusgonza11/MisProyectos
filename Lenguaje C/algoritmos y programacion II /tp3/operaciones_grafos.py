from TDAs_auxiliares import Cola
from TDAs_auxiliares import Pila
from grafo import Grafo


#########################################################
#				OPERACIONES CON GRAFOS					#
#########################################################


def grado_vertices_no_dirigido(grafo):
	"""
	Obtiene el grado de todos los vértices de un grafo no dirigido.
	"""
	grado = {}

	for v in grafo.obtener_vertices():
		grado[v] = len(grafo.adyacentes(v))

	return grado



def grado_salida_vertices_dirigido(grafo):
	"""
	Obtiene el grado de salida de todos los vértices de un grafo dirigido.
	"""
	grado = {}

	for v in grafo.obtener_vertices():
		grado[v] = len(grafo.adyacentes(v))

	return grado


def grado_entrada_vertices_dirigido(grafo):
	"""
	Obtiene el grado de entrada de todos los vértices de un grafo dirigido.
	"""
	grado = {}

	for v in grafo.obtener_vertices():
		for w in grafo.adyacentes(v):
			grado[w] = grado.setdefault(w, 0) + 1

	return grado


def bfs(grafo, origen):
	"""
	Hace un recorrido bfs en un grafo conexo y devuelve el diccionario de padres, de orden, y de visitados
	"""
	visitados = set()
	padres = {}
	orden = {}
	padres[origen] = None
	orden[origen] = 0
	visitados.add(origen)
	q = Cola()
	q.encolar(origen)

	while not q.esta_vacia():
		v = q.desencolar()
		for w in grafo.adyacentes(v):
			if w not in visitados:
				padres[w] = v
				orden[w] = orden[v] + 1
				visitados.add(w)
				q.encolar(w)

	return padres, orden, visitados


def dfs(grafo, origen):
	"""
	Hace un recorrido dfs en un grafo conexo y devuelve el diccionario de padres, de orden, y de visitados
	"""
	padres = {}
	orden = {}
	visitados = set()
	padres[origen] = None
	orden[origen] = 0
	visitados.add(origen)
	_dfs(grafo, origen, visitados, padres, orden)
	return padres, origen, visitados

def _dfs(grafo, v, visitados, padres, orden):
	for w in grafo.adyacentes(v):
		if w not in visitados:
			visitados.add(w)
			padres[w] = v
			orden[w] = orden[v] + 1
			_dfs(grafo, w, visitados, padres, orden)



def es_bipartito(grafo):
	"""
	Determina si un grafo es bipartito
	"""
	color = {}
	VERDE = 1
	ROJO = 2

	#Les pongo None como color a todos los vertices
	for v in grafo.obtener_vertices():
		color[v] = None

	#Establezco un origen
	origen = grafo.obtener_vertices()[0]
	color[origen] = VERDE

	#Uso bfs para recorrer y pintar de distinto color los nodos que sean adyacentes, si encuentro alguno
	#Que ya tenia el mismo color => no es bipartito
	q = Cola()
	q.encolar(origen)

	while not q.esta_vacia():
		nodo = q.desencolar()

		for v in grafo.adyacentes(nodo):
			if (color[v] == color[nodo]): return False

			if color[v] == None:
				if color[nodo] ==VERDE:	color[v] = ROJO
				else:					color[v] = VERDE
				q.encolar(v)

	return True


def orden_topologico_dfs(grafo, origen):
	"""
	Devuelve una lista con el orden topologico de un grafo dirigido
	"""
	resultado = []
	visitados = set()
	pila = Pila()
	for v in grafo.obtener_vertices():
		if v not in visitados:
			_dfs(grafo, v, visitados, pila)

	#Invierto la pila a medida que agrego los vertices en la lista
	while not pila.esta_vacia():
		resultado.append(pila.desapilar())

	return resultado

def _dfs(grafo, v, visitados, pila):
	visitados.add(v)
	for w in grafo.adyacentes(v):
		if w not in visitados:
			_dfs(grafo, w, visitados, pila)
	pila.apilar(v)

def puntos_articulacion(grafo, raiz):
	"""
	Devuelve los puntos de articulacion de un grafo no dirigido
	"""
	visitados = set()
	padre = {}
	orden = {}
	mas_bajo = {}
	p_articulacion = set()
	orden[v] = 0
	padre[v] = None
	_puntos_articulacion(grafo, raiz, True, orden, mas_bajo, visitados, padre, p_articulacion) #Si hay mas de 1 origen, hacer esto con cada origen
	return p_articulacion

def _puntos_articulacion(grafo, v, es_raiz, orden, mas_bajo, visitados, padre, p_articulacion):
	visitados.add(v)
	mas_bajo[v] = orden[v]
	hijos = 0
	
	for w in grafo.adyacentes(v):
		if w not in visitados:
			hijos += 1
			orden[w] = orden[v] + 1
			padre[w] = v
			_puntos_articulacion(grafo, w, False, orden, mas_bajo, visitados, padre, p_articulacion)

			if mas_bajo[w] >= orden[v] and es_raiz == False:
				p_articulacion.add(v)
		
		if padre[v] != w:
			mas_bajo[v] = min(mas_bajo[v], mas_bajo[w])
	  
	if es_raiz and hijos > 1:
		p_articulacion.add(v)



def componentes_fuertemente_conexas(grafo, origen):
	"""
	Devuelve las componentes fuertemente conexas de un grafo dirigido
	"""
	visitados = set()
	orden = {}
	mas_bajo = {}
	cfcs = set()
	orden[v] = 0
	pila = Pila()
	apilados = set()
	_componentes_fuertemente_conexas(grafo, origen, visitados, orden, mas_bajo, pila, apilados, cfcs)
	return cfcs


def _componentes_fuertemente_conexas(grafo, v, visitados, orden, mas_bajo, pila, apilados, cfcs):
	visitados.add(v)
	mas_bajo[v] = orden[v]
	pila.apilar(v)
	apilados.add(v)
	
	
	for w in grafo.adyacentes(v):
		if w not in visitados:
			orden[w] = orden[v] + 1
			_componentes_fuertemente_conexas(grafo, w, visitados, orden, mas_bajo, pila, apilados, cfcs)
	
		if w in apilados:
			mas_bajo[v] = min(mas_bajo[v], mas_bajo[w])
	
	
	if orden[v] == mas_bajo[v] and pila.cantidad() > 0:
		nueva_cfc = []
		while True:
			w = pila.desapilar()
			apilados.remove(w)
			nueva_cfc.append(w)
			if w == v:
				break
	  
		cfcs.append(nueva_cfc)

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
