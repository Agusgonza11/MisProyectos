TestCase subclass: #TestCaso01
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'Chess-Test'!

!TestCaso01 methodsFor: 'tests' stamp: 'DS 7/19/2021 22:34'!
testUnaPiezaBlancaComeNegra
	| piezaNegra tablero piezaBlanca j1 |
	piezaNegra := Pieza color: (Negro new). 
	piezaBlanca := Pieza color: (Blanco new).
	
	tablero := Tablero new.
	
	tablero agregar: piezaNegra en: (Posicion columna: 3 fila: 4).
	tablero agregar: piezaBlanca en: (Posicion columna: 4 fila: 3).
	
	j1 := Jugador juegaEn: tablero conColor: (Negro new).
	
	self assert: (j1 mover: piezaNegra a: (Posicion columna: 4 fila: 3)).
	self assert: (tablero piezaEn: (Posicion columna: 4 fila: 3)) equals: piezaNegra.

	! !

!TestCaso01 methodsFor: 'tests' stamp: 'DS 7/20/2021 09:29'!
testUnaPiezaBlancaNoComeSuCompanera
	| piezaBlanca tablero otraPiezaBlanca j1 |
	piezaBlanca := Pieza color: (Blanco new). 
	otraPiezaBlanca := Pieza color: (Blanco new).
	
	tablero := Tablero new.
	
	tablero agregar: piezaBlanca en: (Posicion columna: 3 fila: 4).
	tablero agregar: otraPiezaBlanca en: (Posicion columna: 4 fila: 3).
	
	j1 := Jugador juegaEn: tablero conColor: (Blanco new).
	
	self deny: (j1 mover: piezaBlanca a: (Posicion columna: 4 fila: 3)).
	

	! !


TestCase subclass: #TestPosicion
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'Chess-Test'!

!TestPosicion methodsFor: 'tests' stamp: 'DS 7/19/2021 22:46'!
testEquals 
	| p1 p2 p3 |
	p1 := Posicion columna: 1 fila: 2.
	p2 := Posicion columna: 1 fila: 2.
	p3 := Posicion columna: 2 fila: 2.
	
	self assert: p1 equals: p2.
	self deny: p1 equals: p3.! !
