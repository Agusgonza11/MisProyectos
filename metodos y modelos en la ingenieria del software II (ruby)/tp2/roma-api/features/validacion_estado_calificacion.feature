# language: es

Característica: 20 - Validar calificacion

  Antecedentes:
    Dado que un usuario realizo un pedido

  Escenario: 20.01 - Calificar un pedido Recibido
    Dado que el pedido esta en estado Recibido  
    Cuando el usuario califica el pedido   
    Entonces recibe el mensaje de que no se puede calificar el pedido

  Escenario: 20.02 - Calificar un pedido En preparacion
    Dado que el pedido esta en estado En preparacion  
    Cuando el usuario califica el pedido   
    Entonces recibe el mensaje de que no se puede calificar el pedido

  Escenario: 20.03  - Calificar un pedido En espera
    Dado que el pedido esta en estado En espera  
    Cuando el usuario califica el pedido   
    Entonces recibe el mensaje de que no se puede calificar el pedido

  Escenario: 20.04 - Calificar un pedido En camino
    Dado que el pedido esta en estado En camino  
    Cuando el usuario califica el pedido   
    Entonces recibe el mensaje de que no se puede calificar el pedido
