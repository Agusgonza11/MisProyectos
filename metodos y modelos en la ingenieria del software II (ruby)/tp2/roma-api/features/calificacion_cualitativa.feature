# language: es

Característica: 8 - Agregar comentario al calificar un pedido

  Antecedentes:
    Dado que realice un pedido
    Y que mi pedido esta en estado Entregado

  Escenario: 8.01 - Agregar comentario en un pedido entregado
    Cuando califico mi pedido con calificacion 5 y con el comentario "Excelente producto"
    Entonces recibo el mensaje de calificacion de pedido con calificacion 5
    Y recibo con el comentario "Excelente producto"
