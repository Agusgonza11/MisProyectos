require 'date'

class CalculadorAlquilerTiempo
  def calcular_tiempo_transcurrido(fecha_alquiler, tipo_alquiler, parametro)
    fecha_alquiler += parametro.to_i if tipo_alquiler == 'd'
    fecha_alquiler += parametro.to_i / 24 if tipo_alquiler == 'h'
    fecha_alquiler
  end

  def calcular_importe(fecha_alquiler, fecha_devolucion, tipo, parametro, precio_base)
    resultado = precio_base
    fecha_devolucion_convertida = DateTime.parse(fecha_devolucion)
    fecha_alquiler_convertida = DateTime.parse(fecha_alquiler)
    tiempo_alquilado = calcular_tiempo_transcurrido(fecha_alquiler_convertida, tipo, parametro)
    resultado *= 2 if tiempo_alquilado < fecha_devolucion_convertida
    resultado
  end
end
