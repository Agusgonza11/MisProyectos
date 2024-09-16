# language: es

Característica: 1 - Registro de usuario

  Escenario: 1.01 - Registro de usuario con nombre, dirección y teléfono.
    Cuando me registro con el nombre "Hernan"
    Y dirección "Cucha Cucha 1234"
    Y teléfono "51213-1234"
    Entonces veo el mensaje de bienvenida a "Hernan"

