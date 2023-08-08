# language: es

Característica: 22 - Enviar repartidor

  Escenario: 22.01 - Enviar un repartidor con 1 menu en la mochila
    Dado que existe un repartidor Disponible
    Y con Menu Individual
    Cuando despacho el repartidor
    Entonces el repartidor esta en estado En Camino con 1 espacio ocupado

  Escenario: 22.02 - Enviar un repartidor con la mochila vacia
    Dado que existe un repartidor Disponible
    Cuando despacho el repartidor
    Entonces el repartidor esta en estado Disponible con 0 espacio ocupado
