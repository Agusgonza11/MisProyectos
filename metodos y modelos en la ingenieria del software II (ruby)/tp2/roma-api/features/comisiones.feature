# language: es

Característica: 17.01 Como La Nonna quiero calcular las comisiones base

  Antecedentes:
    Dado que existe un repartidor "Hernan"

  Escenario: 17.01 - Calcular comision de 1 pedido Menu Individual entregado  
    Dado que existe un pedido de "Menu individual" con precio 100 entregado por el repartidor "Hernan"  
    Cuando calculo la comision  
    Entonces para el repartidor "Hernan" obtengo 5 como comision  

  Escenario: 17.02 - Calcular comision de 2 pedidos entregados  
    Dado que existe un pedido de "Menu individual" con precio 100 entregado por el repartidor "Hernan"  
    Y que existe otro pedido de "Menu familiar" con precio 250 entregado por el repartidor "Hernan"  
    Cuando calculo la comision  
    Entonces para el repartidor "Hernan" obtengo 17.5 como comision

  Escenario: 17.03 - Calcular comision de 1 pedido Menu Individual entregado calificado con 1
    Dado que existe un pedido de "Menu individual" con precio 100 entregado por el repartidor "Hernan"  
    Y se calificó con 1  
    Cuando calculo la comision  
    Entonces para el repartidor "Hernan" obtengo 3 como comision  

  Escenario: 17.04 - Calcular comision de 1 pedido Menu Familiar entregado calificado con 5
    Dado que existe un pedido de "Menu familiar" con precio 250 entregado por el repartidor "Juan"  
    Y se calificó con 5  
    Cuando calculo la comision  
    Entonces para el repartidor "Juan" obtengo 17.5 como comision

  Escenario: 17.05 - Calcular comision de 1 pedido Menu Familiar entregado un dia de lluvia con calificacion 5
    Dado que existe un pedido de "Menu familiar" con precio 250 entregado por el repartidor "Hernan" un dia de lluvia
    Y se calificó con 5
    Cuando calculo la comision
    Entonces para el repartidor "Hernan" obtengo 20 como comision

  Escenario: 17.06 - Calcular comision de 1 pedido Menu Familiar entregado un dia con lluvia con calificacion 1
    Dado que existe un pedido de "Menu familiar" con precio 250 entregado por el repartidor "Hernan" un dia de lluvia
    Y se calificó con 1
    Cuando calculo la comision
    Entonces para el repartidor "Hernan" obtengo 10 como comision

  Escenario: 17.07 - Calcular comision de 1 pedido Menu Familiar entregado un dia con lluvia con calificacion 3
    Dado que existe un pedido de "Menu familiar" con precio 250 entregado por el repartidor "Hernan" un dia de lluvia
    Y se calificó con 3
    Cuando calculo la comision
    Entonces para el repartidor "Hernan" obtengo 15 como comision
