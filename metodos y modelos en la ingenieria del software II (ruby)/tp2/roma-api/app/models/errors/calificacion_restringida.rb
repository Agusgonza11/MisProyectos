class CalificacionRestringida < StandardError
  def initialize
    super('calificacion_restringida')
  end
end
