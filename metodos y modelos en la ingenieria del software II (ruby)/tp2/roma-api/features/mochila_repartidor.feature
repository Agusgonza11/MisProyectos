# language: es
@local
Característica: 3 - Pedido de menú

  Escenario: 21.01 - Despachar un pedido cuando no entra en la mochila del repartidor
    Dado que el repartidor esta sin menus asignados  
    Cuando agrego un pedido Menu Individual  
    Entonces el repartidor tiene 1 de espacio ocupado

  Escenario: 21.02 - Despachar un pedido cuando no entra en la mochila del repartidor  
    Dado que el repartidor esta sin menus asignados  
    Cuando agrego un pedido Menu Parejas  
    Entonces el repartidor tiene 2 de espacio ocupado

  Escenario: 21.03 - Despachar un pedido cuando no entra en la mochila del repartidor  
    Dado que el repartidor esta sin menus asignados  
    Cuando agrego un pedido Menu Familiar  
    Entonces el repartidor tiene 3 de espacio ocupado

  Escenario: 21.04 - Despachar un pedido cuando no entra en la mochila del repartidor  
    Dado que el repartidor tiene un Menu Individual asignado  
    Cuando agrego un pedido Menu Parejas  
    Entonces el repartidor tiene 3 de espacio ocupado

  Escenario: 21.05 - Despachar un pedido cuando no entra en la mochila del repartidor  
    Dado que el repartidor tiene un Menu Individual asignado  
    Cuando agrego un pedido Menu Familiar  
    Entonces el pedido no pudo ser asignado al repartidor
