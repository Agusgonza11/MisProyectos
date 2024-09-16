# language: es

Característica: Validar pedir un menu con pedidos por calificar pendiente

  Escenario: 09.01 - Realizar un pedido con pedido pendiente de calificacion
    Dado que tengo pendiente 1 pedido entregado por calificar
    Cuando realizo el pedido de menú "Menu individual"
    Entonces veo el mensaje de pedido pendiente por calificar
    Y me muestra el pedido pendiente por calificar

  Escenario: 09.02 - Realizar un pedido con dos pedidos pendientes de calificacion
    Dado que tengo pendiente 2 pedido entregado por calificar
    Cuando realizo el pedido de menú "Menu familiar"
    Entonces veo el mensaje de pedido pendiente por calificar
    Y me muestra los pedidos pendientes por calificar