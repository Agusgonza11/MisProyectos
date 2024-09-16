# language: es

Característica: 28 - Autenticacion de la api
  
  Escenario: 28.01 - Autenticacion fallida
    Dado que no estoy autenticado
    Cuando quiero registrarme
    Entonces recibe un error por no estar autorizado

  Escenario: 28.02 - Autenticacion exitosa
    Dado que estoy autenticado
    Cuando quiero registrarme
    Entonces recibe un mensaje de registracion exitosa
