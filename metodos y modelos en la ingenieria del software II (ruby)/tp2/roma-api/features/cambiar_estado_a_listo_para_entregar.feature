# language: es

Característica: 12 - Poner pedido en listo para entregar

  Escenario: 12.01 - Cambiar el estado de un pedido Menu individual, con un repartidor con la mochila vacia
    Dado que existe un pedido de "Menu individual" con estado "En preparacion"
    Y existe un repartidor con la mochila vacia
    Cuando quiero despachar el pedido
    Entonces el estado del pedido está en "En camino"

  Escenario: 12.02 - Cambiar el estado de un pedido Menu parejas, con un repartidor con pedido Menu individual
    Dado que existe un pedido de "Menu parejas" con estado "En preparacion"
    Y existe un repartidor con un pedido de "Menu individual"
    Cuando quiero despachar el pedido
    Entonces el estado del pedido está en "En camino"

  Escenario: 12.03 - Despachar un pedido cuando no hay repartidores
    Dado que existe un pedido de "Menu individual" en preparacion
    Y no hay repartidores
    Cuando despacho el pedido
    Entonces el estado del pedido está en "En espera"

  Escenario: 12.04 - Despachar un pedido en espera luego de agregar un repartidor
    Dado que existe un pedido de "Menu individual" en espera
    Cuando creo un repartidor
    Y despacho el pedido
    Entonces el estado del pedido está en "En camino"
