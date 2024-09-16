class SolicitudClimaError < StandardError
  def initialize
    super('solicitud_clima_error')
  end
end
