# language: es

Característica: 11 - Poner pedido en preparación

  Escenario: 11.01 - Cambiar el estado de un pedido Recibido a En preparación
    Dado que existe un pedido con estado "Recibido"
    Cuando pedido empieza a cocinarse
    Entonces el estado del pedido está en "En preparacion"
