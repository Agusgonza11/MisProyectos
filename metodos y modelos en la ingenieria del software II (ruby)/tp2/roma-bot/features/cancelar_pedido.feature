# language: es
@bot @manual
Característica: 4 - Cancelar un pedido
  
  Antecedentes:
    Dado que realice un pedido

  Escenario: 4.01 - Cancelar un pedido recibido
    Dado que mi pedido esta en estado Recibido
    Cuando cancelo mi pedido
    Entonces recibo el mensaje de cancelacion del pedido
  
  Escenario: 4.02 - Cancelar un pedido en preparacion
    Dado que mi pedido esta en estado En preparacion
    Cuando cancelo mi pedido
    Entonces recibo el mensaje de cancelacion del pedido

  Escenario: 4.03 - Cancelar un pedido en espera
    Dado que mi pedido esta en estado En espera
    Cuando cancelo mi pedido
    Entonces recibo el mensaje de cancelacion del pedido