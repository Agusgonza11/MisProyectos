class PedidoYaCalificado < StandardError
  def initialize
    super('pedido_ya_calificado')
  end
end
