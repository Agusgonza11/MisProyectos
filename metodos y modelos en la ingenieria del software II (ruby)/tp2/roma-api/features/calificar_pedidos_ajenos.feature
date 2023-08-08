# language: es

Característica: Validar calificacion

  Escenario: 24.01 - Calificar un pedido ajeno
    Dado que existe un pedido entregado del usuario "German"
    Cuando el usuario "Hernan" califica el pedido
    Entonces se recibe el mensaje de "No podes operar con el pedido de otro usuario"
