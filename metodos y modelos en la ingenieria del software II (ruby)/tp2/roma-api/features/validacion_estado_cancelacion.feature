# language: es

Característica: 19 - Validacion estado cancelacion

  Antecedentes:
    Dado que un usuario realizo un pedido

  Escenario: 19.01 - Cancelar un pedido en camino
    Dado que el pedido esta en estado En camino
    Cuando el usuario cancela el pedido
    Entonces recibe el mensaje de que no se puede cancelar el pedido

  Escenario: 19.02 - Cancelar un pedido entregado
    Dado que el pedido esta en estado Entregado
    Cuando el usuario cancela el pedido
    Entonces recibe el mensaje de que no se puede cancelar el pedido