# language: es

Característica: 26 Repartidor vuelve al local

  Escenario: 26.01 - Repartidor regresa sin haber entregado sus pedidos
    Dado que existe un repartidor en camino con un pedido de menu individual
    Cuando el repartidor quiere regresar al local sin entregar el pedido
    Entonces el repartidor esta en estado Disponible con 1 espacio ocupado
