# language: es

@manual @bot
Característica: 27 - Validar pedir un menu

  Escenario: 27.01 - Realizar un pedido sin estrar registrado
    Dado que no tengo usuario registrado para "Pablo"
    Cuando pide un menu
    Entonces se recibe el mensaje de error