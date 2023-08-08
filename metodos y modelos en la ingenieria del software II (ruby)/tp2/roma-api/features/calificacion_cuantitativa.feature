# language: es
Característica: 7 - Calificar un pedido

  Antecedentes:
    Dado que realice un pedido
    Y que mi pedido esta en estado Entregado

  Escenario: 7.01 - Calificar un pedido entregado
    Cuando califico mi pedido con calificacion 5
    Entonces recibo el mensaje de calificacion de pedido con calificacion 5

  Escenario: 7.02 - Calificar un pedido más de una vez
    Cuando califico mi pedido con calificacion 3
    Y lo intento calificar nuevamente con calificacion 2
    Entonces recibo el mensaje de que el pedido ya esta calificado
