# TP: malloc

## Integrantes

- Gabriel Peralta Mansilla - 101767
- Tomas Sabao - 99437
- Tomas Del Pup - 102174
- Agustin Nicolas Gonzalez - 106086


## Introducción

En este TP se realiza la implementación de `malloc(3)`, `calloc(3)`, `realloc(3)` y `free(3)`.
A continuación se muestran algunos detalles y supuestos de la implementación de dichas funciones.


## Malloc

La memoria se administra en bloques, y dentro de estas se crean regiones donde se asginaran la
memoria solicitada. Cada una de estas regiones tendra un header que contendrá información sobre el
espacio de esta región; como el tamaño, un id, y si esta libre. Cada bloque solicita memoria con
`mmap`. En un primer llamado a malloc se crea un bloque con 16Kib, y se dividen en dos regiones;
uno con el espacio solicitado y otro con el espacio restante libre. En la primer implementación,
cuando se hacía un siguiente llamado a malloc, simplemente se buscaba la primer región libre con
espacio suficiente, y se volvía a dividir la región.
Luego se implementó un manejador de bloques, para que se puedan agregar nuevas regiones una vez que
un bloque se llene. Los bloques pueden ser de 16Kib, 1Mib o 32Mib segun el espacio requerido. El
manejador de bloques buscará en todos los bloques una region con el espacio suficiente. Por último
se mejoró la busqueda de regiones, para encontrar la región mas chica en todo el bloque que
satisfaga el espacio requerido.


## Free

Primero se obtiene el header de la region y se evalúa si la dirección de memoria coincide con una
solicitada por malloc. Para esto el manejador de bloques verifica en cada bloque si se encuentra la
dirección a liberar. Luego se valida que la región no este libre para después actualizar el header
y hacer un coalescing si la región próxima también está libre. Finalmente, si el bloque en el se
encontraba la región no tiene mas regiones ocupadas, el manejar libera el bloque completo con
`munmap`.


## Calloc

La implementación de calloc es casi idéntica a la de malloc, la única diferencia es que al momento
de que el manejador de bloques crea todo el bloque, lo hace rellenando con "ceros" todas las
posiciones de memoria de ese bloque. Para esto simplemente, con un booleano, se le indica al
manejador que se trata de un calloc.


## Realloc

En el caso en el que se solicite achicar el espacio de memoria, se intenta hacer un split, para
esto debe quedar una región con espacio suficiente para el mínimo requerido, y en tal caso se hace
un coalescing si la región continua a la continua esta libre. Si no hay un espacio mínimo, no se
hace nada.
Para agrandar el espacio, en primer lugar se verifica si la region continua esta libre, y si
combinando las dos regiones se satisface el espacio requerido. Y si esto no se cumple se busca una
region libre con el espacio suficiente en todos los bloques. De no ser asi, se crea un nuevo bloque
para reasignar la memoria, liberando la region anterior.


