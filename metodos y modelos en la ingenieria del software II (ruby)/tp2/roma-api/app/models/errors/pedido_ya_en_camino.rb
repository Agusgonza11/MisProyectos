class PedidoYaEnCamino < StandardError
  def initialize
    super('pedido_ya_en_camino')
  end
end
