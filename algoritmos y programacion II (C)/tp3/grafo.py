import random

class Grafo:
	def	__init__(self, dirigido=False):
		#Por defecto el grafo vendra en formato no dirigido, eso se puede cambiar poniendo
		#True cuando se crea
		self.vertices = {}  	 #Diccionario con los vertices del grafo
		self.cantidad = 0		 #cantidad de vertices del grafo
		self.dirigido = dirigido #Si el grafo es dirigido o no dirigido
		
	def agregar_vertice(self, vertice):
		if vertice in self.vertices or vertice is None:
			return False
		self.vertices[vertice] = {}
		self.cantidad += 1
		return True
		
	def borrar_vertice(self, vertice):
		if vertice not in self.vertices:
			return False
		for v in (self.vertices).keys():
			if vertice in self.vertices[v]:
				(self.vertices[v]).pop(vertice)
		(self.vertices).pop(vertice)
		self.cantidad -= 1
		
	def agregar_arista(self, v1, v2, peso=1):
		if v1 not in self.vertices or v2 not in self.vertices:
			return False
		self.vertices[v1][v2] = peso
		if self.dirigido==False:
			self.vertices[v2][v1] = peso
		
	def borrar_arista(self, v1, v2):
		if v1 not in self.vertices or v2 not in self.vertices:
			return False
		p = self.vertices[v1][v2]
		(self.vertices[v1]).pop(v2)
		if self.dirigido==False:
			(self.vertices[v2]).pop(v1)
		return p
		
	def estan_unidos(self, v1, v2):
		return v2 in self.vertices[v1]
		
	def peso_arista(self, v1, v2):
		if v1 not in self.vertices or v2 not in self.vertices:
			return False
		return self.vertices[v1][v2]
		
	def obtener_vertices(self):
		return list((self.vertices).keys())
		
	def vertice_aleatorio(self):
		return random.list(((self.vertices).keys()))
		
	def adyacentes(self, vertice):
		return list((self.vertices[vertice]).keys())
		
		
		
		
		
		
		
		
		
		
		
		

		
		
