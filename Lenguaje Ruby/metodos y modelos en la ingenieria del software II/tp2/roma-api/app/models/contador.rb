class Contador
  PORCENTAJE_MINIMO = 0.03
  PORCENTAJE_MAXIMO = 0.07
  PORCENTAJE_PREDETERMINADO = 0.05
  PORCENTAJES_CALIFICACIONES = {'1': PORCENTAJE_MINIMO,
                                '2': PORCENTAJE_PREDETERMINADO,
                                '3': PORCENTAJE_PREDETERMINADO,
                                '4': PORCENTAJE_PREDETERMINADO,
                                '5': PORCENTAJE_MAXIMO }.freeze
  CLIMA_LLUVIOSO = 'rain'.freeze

  def calcular_comision(precio_menu, calificacion, clima)
    porcentaje = PORCENTAJE_PREDETERMINADO
    porcentaje = PORCENTAJES_CALIFICACIONES[calificacion.to_s.to_sym] unless calificacion.nil?
    porcentaje += porcentaje_clima(clima)
    precio_menu * porcentaje
  end

  private

  def porcentaje_clima(clima)
    return 0.01 if clima.include? CLIMA_LLUVIOSO

    0
  end
end
