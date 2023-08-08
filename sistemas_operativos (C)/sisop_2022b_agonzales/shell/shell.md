# Lab: shell

Pregunta:
¿cuáles son las diferencias entre la syscall execve(2) y la familia de wrappers proporcionados por la librería estándar de C (libc) exec(3)?  
Respuesta:  
La principal diferencia es que exec (la familia de wrappers) toma las variables del entorno del actual proceso y execve recibe un array con 
las variables de entorno a ejecutar en el programa, sobreescribiendo el espacio de memoria del proceso original.  
  
Pregunta:  
¿Puede la llamada a exec(3) fallar? ¿Cómo se comporta la implementación de la shell en ese caso?  
Respuesta:  
Si, exec(3) puede fallar, y si sucede la shell informa del error en la siguiente linea y quedara a la espera de un nuevo comando.  
  
Pregunta:  
Detallar cuál es el mecanismo utilizado para implementar procesos en segundo plano.  
Respuesta:  
El mecanismo que utiliza la shell para los procesos en segundo plano es que el proceso principal queda esperando a la ejecucion de los procesos 
en segundo plano, esto lo hace usando el flag WHOHANG para que la shell no se bloquee.  
  
Pregunta:  
Investigar el significado de 2>&1, explicar cómo funciona su forma general y mostrar qué sucede con la salida de cat out.txt en el ejemplo. Luego repetirlo invertiendo el orden de las redirecciones. ¿Cambió algo?  
Respuesta:  
Desmenuzando cada uno de los argumentos, partimos de la base que ">" significa una redireccion, y tanto "2" como "1" hacen alusion a los file descriptor 
correspondientes (stderr y stdout), osea que lo que esta haciendo este comando es redireccionar la salida de stderr hacia stdout.  
Lo que se obtiene haciendo el ejemplo es:  
~~~
agus@AgusCD:~$ ls -C /home /noexiste >out.txt 2>&1
agus@AgusCD:~$ cat out.txt
ls: no se puede acceder a '/noexiste': No existe el archivo o el directorio
/home:
agus
~~~
Y lo que sucede cuando se invierte el orden es:  
~~~
agus@AgusCD:~$ ls -C /home /noexiste 2>&1 >out.txt
ls: no se puede acceder a '/noexiste': No existe el archivo o el directorio
agus@AgusCD:~$ cat out.txt
/home:
agus
~~~
  
Pregunta:  
Investigar qué ocurre con el exit code reportado por la shell si se ejecuta un pipe ¿Cambia en algo? ¿Qué ocurre si, en un pipe, alguno de los comandos falla? Mostrar evidencia (e.g. salidas de terminal) de este comportamiento usando bash. Comparar con la implementación del este lab.  
Respuesta:  
La shell reporta el exit code del ultimo comando ejecutado en los pipes. Si alguno de los comando del pipe falla se devolvera el resultado del proximo.  
Si ejecuto el comando en la shell propia de mi pc:
~~~
agus@AgusCD:~$ ls -l | grep Doc | wc
      1       9      56
agus@AgusCD:~$ echo $?
0
agus@AgusCD:~$ ls -l | grep inexistente | echo hola
hola
agus@AgusCD:~$ echo $?
0
~~~
Y si lo ejecuto en mi implementacion:
~~~
agus@AgusCD:~/Documentos/sistemas_operativos/sisop_2022b_agonzales/shell$ ./sh
ls -l | grep Doc | wc
      1       9      56
echo $?
0
ls -l | grep inexistente | echo hola
hola
echo $?
0
~~~
  
Pregunta:  
¿Por qué es necesario hacerlo luego de la llamada a fork(2)?  
Respuesta:  
Es necesario hacerlo luego de la llamada a fork ya que al ser variables temporales solo deben existir dentro de la ejecucion del programa y no dentro de la shell.  
  
Pregunta:  
Pregunta: En algunos de los wrappers de la familia de funciones de exec(3) (las que finalizan con la letra e), se les puede pasar un tercer argumento (o una lista de argumentos dependiendo del caso), con nuevas variables de entorno para la ejecución de ese proceso. Supongamos, entonces, que en vez de utilizar setenv(3) por cada una de las variables, se guardan en un array y se lo coloca en el tercer argumento de una de las funciones de exec(3).  
¿El comportamiento resultante es el mismo que en el primer caso? Explicar qué sucede y por qué.  
Describir brevemente (sin implementar) una posible implementación para que el comportamiento sea el mismo.
Respuesta:  
No, el comportamiento no es el mismo ya que setenv agrega variables, en cambio, al pasarle las variables de entorno en los parametros se pierden las demas.  
Se podria lograr que el comportamiento sea el mismo agregnado la variable global extern char **environ para agregarle las variables temporales.  
  
Pregunta:  
Investigar al menos otras tres variables mágicas estándar, y describir su propósito. Incluir un ejemplo de su uso en bash (u otra terminal similar).  
Respuesta:  
Decidi mostrar un ejemplo de $$, que con un echo devuelve el pid del proceso en ejecucion  
~~~
agus@AgusCD:~$ echo $$
7890
~~~
Tambien esta $! que devuelve el PID del ultimo proceso ejecutado en segundo plano
~~~
agus@AgusCD:~$ evince Descargas &
[1] 8156
agus@AgusCD:~$ echo $!
8156
~~~
Y por ultimo muestro $_ que devuelve el ultimo argumento del comando anterior
~~~
agus@AgusCD:~$ echo hola como estas
hola como estas
agus@AgusCD:~$ echo $_
estas
~~~

Pregunta:  
¿Entre cd y pwd, alguno de los dos se podría implementar sin necesidad de ser built-in? ¿Por qué? ¿Si la respuesta es sí, cuál es el motivo, entonces, de hacerlo como built-in? (para esta última pregunta pensar en los built-in como true y false)  
Respuesta:  
Si, pwd por ejemplo se podria implementar sin ser built-in, el motivo de hacerlo como built-in esta en que se ahorra syscalls como fork y wait  

