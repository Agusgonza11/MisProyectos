Object subclass: #Blanco
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'Chess'!

!Blanco methodsFor: 'as yet unclassified' stamp: 'DS 7/19/2021 23:01'!
mismoColor: aColor 
	^self class = (aColor class)! !


Object subclass: #Celda
	instanceVariableNames: 'pieza posicion'
	classVariableNames: ''
	package: 'Chess'!

!Celda methodsFor: 'as yet unclassified' stamp: 'DS 7/19/2021 23:00'!
pieza
	^ pieza! !

!Celda methodsFor: 'as yet unclassified' stamp: 'DS 7/19/2021 22:55'!
es: aPosicion 
	^posicion = aPosicion.! !

!Celda methodsFor: 'as yet unclassified' stamp: 'DS 7/20/2021 09:25'!
contenido: aPieza 
	pieza := aPieza .! !

!Celda methodsFor: 'as yet unclassified' stamp: 'DS 7/19/2021 22:59'!
con: aPieza en: aPosicion
	pieza := aPieza.
	posicion := aPosicion.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Celda class
	instanceVariableNames: ''!

!Celda class methodsFor: 'as yet unclassified' stamp: 'DS 7/19/2021 23:00'!
con: aPieza en: aPosicion
	|result|
	result := self new.
	result con: aPieza en: aPosicion .
	^result.! !


Object subclass: #Jugador
	instanceVariableNames: 'color tablero'
	classVariableNames: ''
	package: 'Chess'!

!Jugador methodsFor: 'as yet unclassified' stamp: 'DS 7/19/2021 22:36'!
mover: aPieza a: aPosicion 
	^tablero mover: aPieza  a: aPosicion.! !

!Jugador methodsFor: 'as yet unclassified' stamp: 'DS 7/19/2021 22:21'!
result
	self shouldBeImplemented.! !


!Jugador methodsFor: 'accessing' stamp: 'DS 7/19/2021 22:24'!
juegaEn: aTablero conColor: aColor 
	tablero := aTablero.
	color := aColor.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Jugador class
	instanceVariableNames: 'color'!

!Jugador class methodsFor: 'as yet unclassified' stamp: 'DS 7/19/2021 22:23'!
juegaEn: aTablero conColor: aColor 
	|result|
	result := self new.
	result juegaEn: aTablero conColor: aColor.
	^result.! !


Object subclass: #Negro
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'Chess'!

!Negro methodsFor: 'as yet unclassified' stamp: 'DS 7/20/2021 09:26'!
mismoColor: aColor 
	^self class = (aColor class )! !


Object subclass: #Pieza
	instanceVariableNames: 'color'
	classVariableNames: ''
	package: 'Chess'!

!Pieza methodsFor: 'as yet unclassified' stamp: 'DS 7/19/2021 23:03'!
mismoColor: aPieza 
	^aPieza mismoColor: color.! !

!Pieza methodsFor: 'as yet unclassified' stamp: 'DS 7/19/2021 22:12'!
color: aColor 
	color := aColor	
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Pieza class
	instanceVariableNames: ''!

!Pieza class methodsFor: 'as yet unclassified' stamp: 'DS 7/19/2021 22:12'!
color: aColor 
	|result|
	
	result := self new.
	
	result color: aColor.
	
	^result.! !


Object subclass: #Posicion
	instanceVariableNames: 'fila columna'
	classVariableNames: ''
	package: 'Chess'!

!Posicion methodsFor: 'as yet unclassified' stamp: 'DS 7/19/2021 22:41'!
mismaFila: anInteger 
	^(fila = anInteger).! !

!Posicion methodsFor: 'as yet unclassified' stamp: 'DS 7/19/2021 22:41'!
mismaColumna: anInteger 
	^(columna = anInteger)! !

!Posicion methodsFor: 'as yet unclassified' stamp: 'DS 7/19/2021 22:42'!
columna: aX fila: aY 
	columna := aX.
	fila := aY.! !


!Posicion methodsFor: 'comparing' stamp: 'DS 7/19/2021 22:42'!
= oPosicion
	^(oPosicion mismaColumna: columna) and: (oPosicion mismaFila: fila).! !

!Posicion methodsFor: 'comparing' stamp: 'DS 7/19/2021 22:41'!
asString 
	^columna asString, ', ', fila asString.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Posicion class
	instanceVariableNames: ''!

!Posicion class methodsFor: 'as yet unclassified' stamp: 'DS 7/19/2021 22:34'!
columna: aX fila: aY 
	|result|
	result := self new.
	
	result columna: aX fila: aY.
	^result.! !


Object subclass: #Tablero
	instanceVariableNames: 'celdas'
	classVariableNames: ''
	package: 'Chess'!

!Tablero methodsFor: 'as yet unclassified' stamp: 'DS 7/20/2021 09:27'!
contenidoDe: aPosicion 
	|celdaContenido|
	celdaContenido := self buscarCeldaEn: aPosicion .
	
	celdaContenido isNil ifTrue: [
		^nil.
	] ifFalse: [ 
		^celdaContenido pieza.
	]! !

!Tablero methodsFor: 'as yet unclassified' stamp: 'DS 7/20/2021 09:24'!
buscarCeldaEn: aPosicion 
	^celdas detect: [ :c | c es: aPosicion  ] ifNone: [  nil ].! !

!Tablero methodsFor: 'as yet unclassified' stamp: 'DS 7/19/2021 22:56'!
piezaEn: aPosicion 
	^self contenidoDe: aPosicion .! !

!Tablero methodsFor: 'as yet unclassified' stamp: 'DS 7/20/2021 09:25'!
mover: aPieza a: aPosicion 
	| piezaEnPosicion |
	piezaEnPosicion := self contenidoDe: aPosicion.
	
	(piezaEnPosicion mismoColor: aPieza ) ifTrue: [ 
		^false.
	].

	self colocar: aPieza en: aPosicion.
	^true.! !

!Tablero methodsFor: 'as yet unclassified' stamp: 'DS 7/20/2021 09:24'!
colocar: aPieza en: aPosicion 
	|celda|
	
	celda := self buscarCeldaEn: aPosicion.
	celda contenido: aPieza.! !

!Tablero methodsFor: 'as yet unclassified' stamp: 'DS 7/19/2021 23:00'!
agregar: aPieza en: aPosicion 
	celdas add: (Celda con: aPieza en: aPosicion ).! !


!Tablero methodsFor: 'initialization' stamp: 'DS 7/19/2021 22:51'!
initialize
	celdas := OrderedCollection new.! !
