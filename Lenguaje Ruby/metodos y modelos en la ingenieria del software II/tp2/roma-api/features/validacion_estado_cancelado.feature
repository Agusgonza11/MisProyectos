# language: es

Característica: Validar cancelacion

  Escenario: 25.01 - Cancelar un pedido ajeno
    Dado que existe un pedido recibido del usuario "German"
    Cuando el usuario "Hernan" cancela el pedido
    Entonces se recibe el mensaje de "No podes operar con el pedido de otro usuario"