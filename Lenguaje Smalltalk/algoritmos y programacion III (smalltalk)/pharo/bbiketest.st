TestCase subclass: #PruebasBikeRental
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'BikeRental-Tests'!

!PruebasBikeRental methodsFor: 'tests' stamp: 'DS 6/26/2020 08:44'!
test02AlquilerBiciPorPeriodoDe5
| unaBici unAlquiler unCliente |

unaBici := Bici new.
unaBici establecerPrecio: 3.

unAlquiler := AlquilerPeriodo renta: unaBici por: 5 .

unCliente := Cliente new.
unCliente agregarAlquiler: unAlquiler.
self assert: unCliente saldoAPagar equals: 15.! !

!PruebasBikeRental methodsFor: 'tests' stamp: 'DS 6/26/2020 08:47'!
test01PruebasBicicleta1
| unaBici unAlquiler unCliente |

unaBici := Bici new.
unaBici establecerPrecioPorDia: 10.

unAlquiler := AlquilerDiario renta: unaBici .

unCliente := Cliente new.
unCliente agregarAlquiler: unAlquiler.
self assert: unCliente saldoAPagar equals: 10.! !
