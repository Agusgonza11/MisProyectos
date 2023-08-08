1)
def calcular_grados(grafo):
	gr = {}
	for v in grafo.obtener_vertices():
		gr[v] = 0
	for v in grafo.obtener_vertices():
		for w in grafo.obtener_adyacentes(v):
			gr[v] += 1
	return gr


def k_core(grafo, k):
	resultado = []
	for v in grafo.obtener_vertices():
		resultado.append(v)
	grados = calcular_grados(grafo)
	for v in grados.keys():
		if grados[v] < k:
			resultado.pop(v)
			for w in grafo.obtener_adyacentes(v):
				if w not in resultado: continue
				grados[w] -= 1
				if grados[w] < k:
					resultado.pop(w)
					
	return resultado



3)
def bfs_equipos(grafo, visitados, origen):
	EQUIPO_1 = True
	EQUIPO_2 = False
	equipo = {}
	for v in grafo.vertices:
		equipo[v] = None
	equipo[origen] = EQUIPO_1
	cola = Cola()
	cola.encolar(origen)
	while not cola.esta_vacia():
		v = cola.desencolar()
		if v not in visitados: visitados.add(v)
		for w in grafo.obtener_adyacentes(v):
			if equipo[v] == equipo[w]:
				return False
			if equipo[w] == None:
				if equipo[v] == EQUIPO_1:
					equipo[w] = EQUIPO_2:
				else:
					equipo[w] = EQUIPO_1
				cola.encolar(w)
	return True

def equipos(grafo): #Esta funcion esta para asegurarme de recorrer todas las componentes conexas
	visitados = set()
	for v in grafo.obtener_vertices():
		if v not in visitados:
			resultado = bfs_equipos(grafo, visitados, v)
			if resultado == False:
				return False
	return True

#El tipo de recorrido que usa es de un bfs, y la complejidad del algoritmo es
#O(V + E).





