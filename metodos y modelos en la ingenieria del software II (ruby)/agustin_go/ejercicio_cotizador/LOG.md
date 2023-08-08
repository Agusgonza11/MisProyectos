Pasos en la realizacion del ejercicio:  
  
1) Primero subo la carpeta base que utilizare para el ejercicio, esta contendra la carpeta features ya que decidi realizar las pruebas de aceptacion con cucumber    

2) Agrego las pruebas automatizadas de cucumber (con el wip)  

3) Agrego la clase auto que por ahora solo tiene una clase cotizar que devuelve 1000  

4) Agrego la posibilidad de cotizar agregando cilindradas  

5) Agrego los kilometros para tambien calcular el valor de mercado  

6) Agrego el vehiculo camioneta con las mismas funcionalidades que el auto aunque con un coeficiente y precio base distinto  

7) Agrego la clase vehiculo para que hereden de ellas la clase auto y camioneta  

8) Agrego la clase cotizador que me servira, se podria decir a modo de intermediario, la voy a usar para que los vehiculos hagan su cotizacion  

9) Agrego la fabrica de pedidos para poder crear el objeto acorde al string ingresado por entrada  

10) Hago refactor en varias partes del codigo para ya meter la app.rb y hacer que pase el primer test de aceptacion  

11) Agrego la clase cilindrada, la voy a usar para que un vehiculo tenga una cilindrada y le pueda delegar los calculos que le competen  

12) Agrego la clase camion  

13) Agrego presentador de cotizacion para aislar la entrada/salida.  
Aca lo que hago es que el valor de mercado se trunque en la clase presentador cotizacion, ya que supongo que el valor de mercado es algo que debe tener varios
decimales, pero solo se decide mostrar el primero a la hora de presentarlo  

14) Agrego logica funcional a la clase cilindrada, para ahora usarla para delegarle algunos calculos, tambien al modificarla tuve que cambiar todos los spec   

15) Ahora voy a crear una fabrica de cilindradas, simil de fabrica de vehiculos. Pense en hacer una cilindrada minima, media y maxima pero al no saber como funcionan a ciencia cierta las cilindradas, es decir, si hay mas categorias o siquiera si es correcto denominarslas asi, decidi crear una sola clase cilindrada con su valor como atributo.  

16) Agrego error de vehiculo inexistente a la fabrica de pedidos, tambien agrego sus specs  

17) Hago que el presentador de cotizacion presente el error de vehiculo invalido  

18) Agrego el error de cilindradas invalidas  

19) Elimino la clase cotizador ya que me di cuenta que no estaba cumpliendo ninguna funcionalidad en especial y agrego un error de kilometraje invalido, este solo saltara cuando el vehiculo reciba como kilometraje un numero negativo, ya que esto no tiene mucho sentido. No agregue el caso de que en vez de un numero se pase un string cualquiera, ya que el to_i en ese caso lo convierte a 0, entonces contemple que si no se pasaba un kilometraje que no sea un numero, directamente se quede como que es 0  

20) Por ultimo hago algunas correcciones y agrego specs de casos que habia olvidado probar para aumentar la cobertura  


