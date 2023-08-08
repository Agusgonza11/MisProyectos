require_relative 'luchador.rb'

PUNTAJE_HUMANO = 1
MULTIPLICADOR_HUMANO_EN_CIUDAD = 2

class Humano < Luchador
  def initialize
    @puntaje = PUNTAJE_HUMANO
  end

  def puntaje_por_escenario(escenario)
    puntaje_final = @puntaje
    puntaje_final *= MULTIPLICADOR_HUMANO_EN_CIUDAD if escenario == 'ciudad'
    puntaje_final
  end
end
