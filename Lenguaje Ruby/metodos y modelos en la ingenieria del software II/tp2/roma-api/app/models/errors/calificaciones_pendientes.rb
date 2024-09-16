class CalificacionesPendientes < StandardError
  def initialize
    super('calificaciones_pendientes')
  end
end
