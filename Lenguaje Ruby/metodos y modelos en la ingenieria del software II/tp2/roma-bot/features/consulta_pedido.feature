# language: es

Característica: 5 - Consulta estado de pedido

  @bot @manual
  Escenario: 5.01 - Consulta de un pedido en estado Recibido 
    Dado que tengo un pedido con id 1 
    Y esta en estado "Recibido"
    Cuando consulto el estado del pedido con id 1
    Entonces veo el mensaje de estado "Recibido"

  @bot @manual
  Escenario: 5.02 - Consulta de un pedido en estado En preparación
    Dado que tengo un pedido con id 2 
    Y esta en estado "En preparación"
    Cuando consulto el estado del pedido con id 2
    Entonces veo el mensaje de estado "En preparación"

  @bot @manual
  Escenario: 5.03 - Consulta de un pedido en espera
    Dado que tengo un pedido con id 3 
    Y esta en estado "En espera"
    Cuando consulto el estado del pedido con id 3
    Entonces veo el mensaje de estado "En espera"

  @bot @manual
  Escenario: 5.04 - Consulta de un pedido en estado En camino
    Dado que tengo un pedido con id 4 
    Y esta en estado "En camino"
    Cuando consulto el estado del pedido con id 4
    Entonces veo el mensaje de estado "En camino"

  @bot @manual
  Escenario: 5.05 - Consulta de un pedido en estado Entregado
    Dado que tengo un pedido con id 5
    Y esta en estado "Entregado"
    Cuando consulto el estado del pedido con id 5
    Entonces veo el mensaje de estado "Entregado"
