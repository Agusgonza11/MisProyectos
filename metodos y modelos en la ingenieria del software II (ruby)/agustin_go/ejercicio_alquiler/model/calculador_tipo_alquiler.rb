class CalculadorAlquilerTipo
  def calcular_importe(tipo_alquiler, parametro_alquiler)
    return parametro_alquiler.to_i * 100 if tipo_alquiler == 'h'
    return parametro_alquiler.to_i * 2000 if tipo_alquiler == 'd'
    return ((parametro_alquiler.to_i * 10) + 100) if tipo_alquiler == 'k'
  end
end
