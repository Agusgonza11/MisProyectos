class CalificacionesPendientes < StandardError
  attr_reader :pedidos_pendientes
  def initialize(pedidos_pendientes)
    @pedidos_pendientes = pedidos_pendientes
  end
end
