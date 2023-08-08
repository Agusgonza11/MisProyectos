# language: es

Característica: 5 - Consulta estado de pedido

  Escenario: 5.01 - Consulta de un pedido en estado Recibido 
    Dado que tengo un pedido
    Y esta en estado "Recibido"
    Cuando consulto el estado del pedido
    Entonces veo el mensaje de estado "Recibido"

  Escenario: 5.02 - Consulta de un pedido en estado En preparación
    Dado que tengo un pedido
    Y esta en estado "En preparacion"
    Cuando consulto el estado del pedido
    Entonces veo el mensaje de estado "En preparacion"

  Escenario: 5.03 - Consulta de un pedido en espera
    Dado que tengo un pedido
    Y esta en estado En espera
    Cuando consulto el estado del pedido
    Entonces veo el mensaje de estado "En espera"

  Escenario: 5.04 - Consulta de un pedido en estado En camino
    Dado que tengo un pedido
    Y esta en estado "En camino"
    Cuando consulto el estado del pedido
    Entonces veo el mensaje de estado "En camino"

  Escenario: 5.05 - Consulta de un pedido en estado Entregado
    Dado que tengo un pedido
    Y esta en estado "Entregado"
    Cuando consulto el estado del pedido
    Entonces veo el mensaje de estado "Entregado"
