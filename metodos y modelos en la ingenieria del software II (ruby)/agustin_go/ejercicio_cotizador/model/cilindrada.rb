class Cilindrada
  COEFICIENTE_BASE_IMPOSITIVO = 1_000_000

  def initialize(cilindrada)
    @cilindradas = cilindrada
  end

  def calcular_coeficiente(precio_base)
    (@cilindradas * precio_base) / COEFICIENTE_BASE_IMPOSITIVO
  end

  def calcular_valor(kilometraje)
    @cilindradas + kilometraje
  end
end
