# language: es

Característica: 18 - Entregar pedido

  Escenario: 18.01 - Cambiar el estado de un pedido En camino a Entregado
    Dado que existe un pedido con estado En camino
    Cuando el pedido es entregado
    Entonces el estado del pedido está en "Entregado"
