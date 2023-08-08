class ValorDeCalificacionInvalido < StandardError
  def initialize
    super('valor_calificacion_invalido')
  end
end
