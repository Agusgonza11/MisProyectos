# language: es

Característica: Cotizador de vehiculos

  Escenario: Cotizo un auto de 1000 cilindradas y 1000 kilometros
    Dado un "auto" con 1000 cilindradas y 1000 kilometros
    Cuando lo cotizo
    Entonces su coeficiente impositivo es 1 y su valor de mercado es 500.0

  Escenario: Cotizo una camioneta de 1600 cilindradas y 500 kilometros
    Dado una "camioneta" con 1600 cilindradas y 500 kilometros
    Cuando lo cotizo
    Entonces su coeficiente impositivo es 2 y su valor de mercado es 1428.6

  Escenario: Cotizo un camion de 2000 cilindradas y 0 kilometros
    Dado un "camion" con 2000 cilindradas y 0 kilometros
    Cuando lo cotizo
    Entonces su coeficiente impositivo es 4 y su valor de mercado es 2000

  Escenario: Cotizo un auto de 2000 cilindradas y 10000 kilometros
    Dado un "auto" con 2000 cilindradas y 10000 kilometros
    Cuando lo cotizo
    Entonces su coeficiente impositivo es 2 y su valor de mercado es 181.8