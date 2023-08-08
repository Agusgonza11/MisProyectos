class PedidoYaEntregado < StandardError
  def initialize
    super('pedido_ya_entregado')
  end
end
