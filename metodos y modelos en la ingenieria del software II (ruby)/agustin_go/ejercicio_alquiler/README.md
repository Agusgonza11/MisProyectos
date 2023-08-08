## Alquiler de autos

Construir una aplicación de línea de comandos que a partir de los datos de un alquiler calcule el importe a facturar.

```
# la aplicación debe funcionar siendo invocada de la siguiente forma
ruby app.rb <fecha_alquiler> <fecha_devolucion> <cuit> <tipo_alquiler> <parametros_alquiler>

# y debe generar una salida por la terminal como la siguiente
importe:<importe>

```

Donde:
* tipo_alquier: puede tomar valores h, d o k según el alquiler sea por día, hora o kilómetros respectivamente
* parametros_alquiler: pueden ser cantidad de horas, dias o kilómetros según el tipo de alquiler indicado

Respecto de los tipos de alquileres:
* Por hora: el cliente debe pagar por cada hora que alquila el auto. El costo es de $ 100 / hora.
* Por día: el cliente paga un monto fijo por día (el día son 24 horas) no importa si el auto se devuelve antes. La cantidad de días debe definir al momento del alquiler. El costo es de $ 2000 / día
* Por kilometraje: el cliente paga un precio fijo por cada kilómetros recorrido durante el período de alquiler. Este tipo de alquiler implica devolución dentro del mismo día de alquiler. El costo $ 100 de base más $ 10/km.

Al mismo tiempo hay una serie de reglas de facturación:

* Si quien alquila es una empresa (cuit empieza con 26) tiene un descuento del 5% como parte de la política de fidelización de clientes
* Si el auto es devuelto luego de finalizado el tiempo establecido al momento de alquiler, se cobra un recargo del 100%.

Ejemplo:
```
ruby app.rb 20190119 20190119 20112223336 h 3
importe: 300

```
