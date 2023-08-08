class LaNonna
  def initialize(repartidores = [])
    @repartidores = repartidores
  end

  def asignar_repartidor(pedido)
    @repartidores.each do |repartidor|
      begin
        repartidor.asignar_pedido(pedido)
        return
      rescue NoHayEspacio
        # ignored
      end
    end

    raise NoHayRepartidores
  end

  def self.calcular_comision(pedidos, contador)
    comision = 0
    pedidos.each do |pedido|
      comision += pedido.obtener_comision(contador)
    end
    comision
  end

  def self.validar_calificaciones_pendientes(pedidos)
    raise CalificacionesPendientes if pedidos.size.positive?
  end
end
