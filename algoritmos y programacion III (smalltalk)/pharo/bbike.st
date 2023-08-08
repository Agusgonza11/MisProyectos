Object subclass: #AlquilerDiario
	instanceVariableNames: 'unBien'
	classVariableNames: ''
	package: 'BikeRental'!

!AlquilerDiario methodsFor: 'as yet unclassified' stamp: 'DS 6/26/2020 08:53'!
deuda
	| alquiler nuevaBici nuevoBien |
	nuevoBien := unBien porDia.
	alquiler := AlquilerPeriodo renta: nuevoBien  por: 1. 
	^alquiler deuda.! !

!AlquilerDiario methodsFor: 'as yet unclassified' stamp: 'DS 6/25/2020 22:21'!
renta: aBici 
	unBien := aBici .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

AlquilerDiario class
	instanceVariableNames: ''!

!AlquilerDiario class methodsFor: 'as yet unclassified' stamp: 'DS 6/25/2020 21:43'!
renta: aBici 
	|result|
	result := self new.
	
	result renta: aBici.
	
	^result .! !


Object subclass: #AlquilerPeriodo
	instanceVariableNames: 'unBien numeroDias'
	classVariableNames: ''
	package: 'BikeRental'!

!AlquilerPeriodo methodsFor: 'as yet unclassified' stamp: 'DS 6/25/2020 22:03'!
deuda
	^unBien deudaPorPeriodo: numeroDias ! !

!AlquilerPeriodo methodsFor: 'as yet unclassified' stamp: 'DS 6/25/2020 21:52'!
renta: aBici por: anInteger 
	unBien := aBici.
	numeroDias := anInteger .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

AlquilerPeriodo class
	instanceVariableNames: ''!

!AlquilerPeriodo class methodsFor: 'as yet unclassified' stamp: 'DS 6/25/2020 21:52'!
renta: aBici por: numeroDeDias 
	|result|
	
	result := self new.
	
	result renta: aBici por: numeroDeDias .
	
	^result.! !


Object subclass: #Bici
	instanceVariableNames: 'precio precioPorDia'
	classVariableNames: ''
	package: 'BikeRental'!

!Bici methodsFor: 'as yet unclassified' stamp: 'DS 6/25/2020 22:07'!
deudaDiaria

	^precioPorDia ! !

!Bici methodsFor: 'as yet unclassified' stamp: 'DS 6/25/2020 22:04'!
deudaPorPeriodo: numeroDias
	^precio * numeroDias ! !

!Bici methodsFor: 'as yet unclassified' stamp: 'DS 6/26/2020 08:53'!
porDia
	|result|
	
	result := Bici new.
	result establecerPrecio: precioPorDia.
	
	^result.! !


!Bici methodsFor: 'accessing - private' stamp: 'PabloSuarez 6/29/2016 09:56'!
establecerPrecioPorDia: unPrecio

	precioPorDia := unPrecio.! !

!Bici methodsFor: 'accessing - private' stamp: 'PabloSuarez 6/29/2016 09:56'!
establecerPrecio: unPrecio

	precio := unPrecio.! !


Object subclass: #Cliente
	instanceVariableNames: 'alquileres'
	classVariableNames: ''
	package: 'BikeRental'!

!Cliente methodsFor: 'as yet unclassified' stamp: 'DS 6/25/2020 22:01'!
saldoAPagar

	| resultado |
	
	resultado := 0.
	
	alquileres do: [ :a | 
			resultado := resultado + a deuda. 
	].
		
	^ resultado ! !

!Cliente methodsFor: 'as yet unclassified' stamp: 'PabloSuarez 6/29/2016 10:23'!
agregarAlquiler: unAlquiler

	alquileres add: unAlquiler .! !


!Cliente methodsFor: 'intializing' stamp: 'PabloSuarez 6/29/2016 10:58'!
initialize
	super initialize.
	
	alquileres := OrderedCollection new.! !
