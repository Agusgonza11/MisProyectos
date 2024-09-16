class Luchador
  attr_accessor :puntaje

  def puntaje_por_arma(arma)
    arma.calcular_puntaje(@puntaje)
  end

  def obtener_puntaje(escenario, arma)
    puntaje_por_arma(arma) + puntaje_por_escenario(escenario)
  end
end
