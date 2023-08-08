class PedidoNoEntregado < StandardError
  def initialize
    super('pedido_no_entregado')
  end
end
