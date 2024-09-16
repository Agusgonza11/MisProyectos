class PedidoNoEncontrado < StandardError
  def initialize
    super('pedido_no_encontrado')
  end
end
