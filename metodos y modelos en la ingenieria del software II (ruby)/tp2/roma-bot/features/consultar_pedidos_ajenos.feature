# language: es

@manual @bot
Característica: Validar consulta

  Escenario: 23.01 - Consultar un pedido ajeno
    Dado que existe un pedido del usuario "German"
    Cuando el usuario "Hernan" consulta el pedido
    Entonces se recibe el mensaje de "No podes operar con el pedido de otro usuario"