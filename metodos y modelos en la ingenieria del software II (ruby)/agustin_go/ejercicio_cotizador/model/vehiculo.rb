require_relative '../errors/kilometraje_invalido.rb'

class Vehiculo
  def cotizar(cilindradas, kilometraje)
    raise KilometrajeInvalido if kilometraje.negative?

    coeficiente_impositivo = cilindradas.calcular_coeficiente(@precio_base)
    valor_mercado = calcular_valor_mercado(coeficiente_impositivo, cilindradas, kilometraje)
    [coeficiente_impositivo, valor_mercado]
  end
end

class Auto < Vehiculo
  PRECIO_BASE = 1000
  COEFICIENTE = 0.001

  def initialize
    @precio_base = PRECIO_BASE
  end

  def calcular_valor_mercado(co_impositivo, _cilindradas, kilometraje)
    (co_impositivo * @precio_base) / (1 + COEFICIENTE * kilometraje)
  end
end

class Camion < Vehiculo
  PRECIO_BASE = 2000
  COEFICIENTE = 0.002

  def initialize
    @precio_base = PRECIO_BASE
  end

  def calcular_valor_mercado(co_impositivo, cilindradas, kilometraje)
    (co_impositivo * @precio_base) / (cilindradas.calcular_valor(kilometraje) * COEFICIENTE)
  end
end

class Camioneta < Vehiculo
  PRECIO_BASE = 1500
  COEFICIENTE = 0.003

  def initialize
    @precio_base = PRECIO_BASE
  end

  def calcular_valor_mercado(co_impositivo, cilindradas, kilometraje)
    3 * (co_impositivo * @precio_base) / (cilindradas.calcular_valor(kilometraje) * COEFICIENTE)
  end
end
