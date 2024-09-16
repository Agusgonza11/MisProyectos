from TDAs_auxiliares import Cola
from TDAs_auxiliares import Pila
import sys
from grafo import Grafo
import operaciones_grafos





def divulgacion_de_rumor(grafo, delincuente, n):
	resultado = []
	padres, orden, _ = operaciones_grafos.bfs(grafo, delincuente)
	for v in grafo.obtener_vertices():
		if orden[v] <= n:
			resultado.append(v)
	print(resultado)
	
def imprimir_arreglo(padres, ultimo, origen):
	actual = origen
	while True:
		print(actual)
		print(" -> ")
		actual = padres[actual]
		if actual == ultimo:
			break
	print(origen)
	
def ciclo_de_largo_n(grafo, delincuente, n):
	padres, orden, _ = operaciones_grafos.bfs(grafo, delincuente)
	for v, o in orden.values():
		if o == n-1 and delincuente in grafo.adyacentes(v):
			imprimir_arreglo(padres, v, delincuente)
			break
	print("No se encontro recorrido")


def procesar_comandos(grafo, ingresado):
	if ingresado[:7] == "divulgar":
		_, delincuente, n = ingresado.split(" ")
		divulgacion_de_rumor(grafo, delincuente, n)
	if ingresado[:13] == "divulgar_ciclo":
		_, delincuente, n = ingresado.split(" ")
		ciclo_de_largo_n(grafo, delincuente, n)



def procesar_archivo(arch):
	grafo = Grafo(True)
	with open(archivo, "r") as archivo:
		for lineas in archivo:
			criminal1, criminal2 = lineas.split("    ").rstrip("\n")
			grafo.agregar_vertice(criminal1)
			grafo.agregar_vertice(criminal2)
			if not grafo.estan_unidos(criminal1, criminal2):
				grafo.agregar_arista(criminal1, criminal2)
			
	return grafo


def main():
	if(sys.argv)!=1: 
		raise Exception("No se encuentran los parametros requeridos")
	grafo = procesar_archivo(sys.argv[1])
	while True:
		ingresado = input()
		if ingresado == "":
			break
		procesar_comandos(grafo, ingresado)
	

	
	
	
	
	
	
	
		
