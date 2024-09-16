class PedidoError < StandardError
  attr_reader :id
  def initialize(id)
    @id = id
  end
end
