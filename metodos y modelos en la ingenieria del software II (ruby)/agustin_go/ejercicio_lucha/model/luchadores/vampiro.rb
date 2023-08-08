require_relative 'luchador.rb'

PUNTAJE_VAMPIRO = 2
MULTIPLICADOR_VAMPIRO_EN_NOCHE = 2
MULTIPLICADOR_VAMPIRO_EN_LLUVIA = 1

class Vampiro < Luchador
  def initialize
    @puntaje = PUNTAJE_VAMPIRO
  end

  def puntaje_por_escenario(escenario)
    puntaje_final = @puntaje
    puntaje_final *= MULTIPLICADOR_VAMPIRO_EN_NOCHE if escenario == 'noche'
    puntaje_final -= MULTIPLICADOR_VAMPIRO_EN_LLUVIA if escenario == 'lluvia'
    puntaje_final
  end
end
