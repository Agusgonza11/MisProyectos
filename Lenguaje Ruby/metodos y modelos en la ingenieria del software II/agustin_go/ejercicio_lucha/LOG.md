Pasos en la realizacion del ejercicio:
(Cada paso que explico intentare que sea cada uno de los commits)

1) Primer commit solamente para la copia de la carpeta que contendra la aplicacion ademas de poner los test de aceptacion dados por la materia.

2) Commit con un tema muy simple, en una lucha solo hay un participante y la funcion devuelve al mismo como ganador.

3) Agrego simplemente que cuando luchan dos humanos, devuelva que el resultado es un empate.

4) Agrego que cuando lucha un vampiro, siempre va a ganar el vampiro ya sea el luchador 1 o 2.

5) Empiezo a meter la logica de los puntajes, por ahora solo con los humanos y vampiros.

6) Agrego puntaje de lobos.

7) Encapsulo a los tipos de luchadores en clases (No sabia si poner que todas estas hereden de una clase "Luchador", asi que no lo puse pero dejo la idea porque no creo que sea a lo que apunta el ejercicio).

8) Agrego las armas, aca si que no lo separe en clase porque era volver mas engorroso el codigo.

9) Agrego el estadio como escenario, aunque no modifica la ecuacion ya que no tiene ningun efecto.

10) En este commit logro hacer funcionar las pruebas de aceptacion (no habia podido hasta un par de pasos antes que era cuando ya me hubieran andado, porque no tenia el app.rb en la carpeta junto al rake sino en el directorio model, pero en este punto lo corregi) asi que salgo "al ciclo grande" en este paso y ya me vuelvo a meter al ciclo tdd.

11) Agrego ciudad como posibilidad de escenario, ahora los humanos tienen un multiplicador por 2.

12) Agrego noche como escenario, tambien agregue un par de test unitarios que me habia olvidado en los dos commits anteriores.

13) Cambio los puntajes a atributos empezando a orientar hacia la herencia.

14) Creo la clase luchador de la que heredaran, vampiro humano y lobo. Ademas cambio como se estaba considerando la formula para el puntaje en general que me di cuenta que estaba haciendolo de una manera incorrecta.

15) Agrego ahora el bosque como posibilidad de escenario.

16) Agrego una validacion de escenario, haciendo que devuelva error si no esta dentro de los permitidos.

17) Corrijo algunos test y mejoro implementaciones.

18) Cambio algunos detalles de la implementacion.

19) Para finalizar agrego (aunque creo que no era necesario pero lo hago por las dudas) la validacion de armas.

20) Vuelvo a abrir el ejercicio para realizar cambios, me di cuenta que deberia modelar aspectos como las armas y voy a crear la clase validador que se encargara de validar que lo ingresado esta dentro de las reglas de negocio.

21) Agrego la validacion de personajes.

22) Agrego la validacion de armas.

23) Agrego la validacion de escenario (todas estas ultimas con la clase validador)

24) Cambio mas la implementacion, me di cuenta que no era tan necesaria la clase validador, ya que despues debo convertir ese string a objeto, asi que hago que esa mismo metodo devuelva un -1 si no existe. (Aunque me sigue quedando una duda, voy a intentar explicarlo con un ejemplo, yo recibo en la app el string "humano", por lo que entendi de clase yo tendria que a lucha ya pasarle el objeto Humano, pero sucede que no puedo crearlo a priori, porque dentro de la clase Lucha yo tengo que hacer la validacion del modelo de negocio, es decir que humano esta pensado dentro de la logia del juego, porque sino al recibir "perro" tendria que crear el objeto antes de validar si existe dentro del modelo, por eso el pasaje de string a objeto lo hice dentro del modelo lucha y para abstraerlo mas un poco creo en este paso la clase Convertidor).

25) Hago un refactory convirtiendo las armas en objetos. Decidi no convertir en objeto los escenarios ya que al final iba a terminar teniendo mas o menos la misma forma la implementacion, ya que si no comparaba strings iba a tener que comparar objetos.

26) Finalmente solo agrego un test que me habia olvidado y una aclaracion en la app.

27) Lo organizo en carpetas para que quede mas prolijo.