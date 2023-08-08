require_relative 'convertidor.rb'

EMPATE = 'empate'.freeze
GANA_1 = 'gana 1'.freeze
GANA_2 = 'gana 2'.freeze

class Lucha
  attr_accessor :convertidor

  def initialize
    @convertidor = Convertidor.new
  end

  def validar_escenario(escenario)
    escenario_valido = false
    posibles_escenarios = %w[ciudad estadio lluvia bosque noche]
    escenario_valido = true if posibles_escenarios.include?(escenario)
    escenario_valido
  end

  def dar_resultado(primer_puntaje, segundo_puntaje)
    ganador = ''
    ganador = EMPATE if primer_puntaje == segundo_puntaje
    ganador = GANA_1 if primer_puntaje > segundo_puntaje
    ganador = GANA_2 if primer_puntaje < segundo_puntaje
    ganador
  end

  def obtener_ganador(escenario, primer_l, p_arma, segundo_l, s_arma)
    return 'escenario desconocido' unless validar_escenario(escenario)

    primer_arma = @convertidor.convertir_arma(p_arma)
    segunda_arma = @convertidor.convertir_arma(s_arma)
    return 'arma desconocida' if primer_arma == -1 || segunda_arma == -1

    primer_luchador = @convertidor.convertir_luchador(primer_l)
    segundo_luchador = @convertidor.convertir_luchador(segundo_l)
    return 'personaje desconocido' if primer_luchador == -1 || segundo_luchador == -1

    prim_puntaje = primer_luchador.obtener_puntaje(escenario, primer_arma)
    seg_puntaje = segundo_luchador.obtener_puntaje(escenario, segunda_arma)
    dar_resultado(prim_puntaje, seg_puntaje)
  end
end
