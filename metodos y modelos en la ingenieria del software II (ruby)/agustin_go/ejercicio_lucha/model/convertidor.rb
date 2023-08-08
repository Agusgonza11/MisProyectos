require_relative 'luchadores/humano.rb'
require_relative 'luchadores/vampiro.rb'
require_relative 'luchadores/lobo.rb'
require_relative 'armas/mano.rb'
require_relative 'armas/cuchillo.rb'
require_relative 'armas/espada.rb'

MANO = 'mano'.freeze
CUCHILLO = 'cuchillo'.freeze
ESPADA = 'espada'.freeze
HUMANO = 'humano'.freeze
VAMPIRO = 'vampiro'.freeze
LOBO = 'lobo'.freeze

class Convertidor
  def convertir_arma(arma)
    tipo_arma = -1
    tipo_arma = Mano.new if arma == MANO
    tipo_arma = Cuchillo.new if arma == CUCHILLO
    tipo_arma = Espada.new if arma == ESPADA
    tipo_arma
  end

  def convertir_luchador(luchador)
    tipo_luchador = -1
    tipo_luchador = Humano.new if luchador == HUMANO
    tipo_luchador = Vampiro.new if luchador == VAMPIRO
    tipo_luchador = Lobo.new if luchador == LOBO
    tipo_luchador
  end
end
