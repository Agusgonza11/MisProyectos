require_relative 'luchador.rb'
PUNTAJE_LOBO = 3
MULTIPLICADOR_LOBO_EN_BOSQUE = 3

class Lobo < Luchador
  def initialize
    @puntaje = PUNTAJE_LOBO
  end

  def puntaje_por_escenario(escenario)
    puntaje_final = @puntaje
    puntaje_final *= MULTIPLICADOR_LOBO_EN_BOSQUE if escenario == 'bosque'
    puntaje_final
  end
end
