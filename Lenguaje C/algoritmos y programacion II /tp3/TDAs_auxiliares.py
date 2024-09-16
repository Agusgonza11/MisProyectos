#########################################################
#					TDAs AUXILIARES						#
#########################################################


class Cola:
	def __init__(self):
		self.items = []

	def encolar(self, x):
		self.items.append(x)

	def desencolar(self):
		if self.esta_vacia():
			raise ValueError("La cola está vacía")
		return self.items.pop(0)

	def esta_vacia(self):
		return len(self.items) == 0

	def __str__(self):
		res = "< "
		for e in self.items:
			res += str(e) + ", "
		res = res.rstrip(", ") + " <"
		return res

	def ver_tope(self):
		return self.items[0]


class Pila:
	def __init__(self):
		self.items = []

	def esta_vacia(self):
		return len(self.items) == 0

	def apilar(self, x):
		self.items.append(x)
	
	def desapilar(self):
		if self.esta_vacia():
			raise IndexError("La pila está vacía")
		return self.items.pop()

	def __str__(self):
		res = "| "
		for e in self.items:
			res += str(e) + ", "
		res = res.rstrip(", ") + " >"
		return res

	def ver_tope(self):
		return self.items[-1]