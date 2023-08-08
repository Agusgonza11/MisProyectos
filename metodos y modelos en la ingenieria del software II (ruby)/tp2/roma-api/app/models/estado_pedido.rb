class EstadoPedido
  attr_accessor :id

  def avanzar(pedido, _la_nonna)
    pedido.establecer_estado(@estado_siguiente.new)
  end

  def calificar(_pedido, _calificacion, _comentario)
    raise PedidoNoEntregado
  end

  def cancelar(_pedido) end
end

class EstadoPedidoRecibido < EstadoPedido
  ID_ESTADO_RECIBIDO = 'recibido'.freeze

  def initialize
    @id = ID_ESTADO_RECIBIDO
    @estado_siguiente = EstadoPedidoEnPreparacion
  end

  def cancelar(pedido)
    pedido.establecer_estado(EstadoPedidoCancelado.new)
  end
end

class EstadoPedidoEnPreparacion < EstadoPedido
  ID_ESTADO_EN_PREPARACION = 'en_preparacion'.freeze

  def initialize
    @id = ID_ESTADO_EN_PREPARACION
    @estado_siguiente = EstadoPedidoEnCamino
  end

  def avanzar(pedido, la_nonna)
    la_nonna.asignar_repartidor(pedido)
    pedido.establecer_estado(@estado_siguiente.new)
  rescue NoHayRepartidores
    pedido.establecer_estado(EstadoPedidoEnEspera.new)
  end

  def cancelar(pedido)
    pedido.establecer_estado(EstadoPedidoCancelado.new)
  end
end

class EstadoPedidoEnEspera < EstadoPedido
  ID_ESTADO_EN_ESPERA = 'en_espera'.freeze
  def initialize
    @id = ID_ESTADO_EN_ESPERA
    @estado_siguiente = EstadoPedidoEnCamino
  end

  def avanzar(pedido, la_nonna)
    la_nonna.asignar_repartidor(pedido)
    pedido.establecer_estado(@estado_siguiente.new)
  rescue NoHayRepartidores
    # Ignored
  end

  def cancelar(pedido)
    pedido.establecer_estado(EstadoPedidoCancelado.new)
  end
end

class EstadoPedidoEnCamino < EstadoPedido
  ID_ESTADO_EN_CAMINO = 'en_camino'.freeze
  def initialize
    @id = ID_ESTADO_EN_CAMINO
    @estado_siguiente = EstadoPedidoEntregado
  end

  def avanzar(pedido, _la_nonna)
    pedido.entregar
    pedido.establecer_estado(@estado_siguiente.new)
  end

  def cancelar(_pedido)
    raise PedidoYaEnCamino
  end
end

class EstadoPedidoEntregado < EstadoPedido
  ID_ESTADO_ENTREGADO = 'entregado'.freeze
  def initialize
    @id = ID_ESTADO_ENTREGADO
  end

  def avanzar(_pedido, _la_nonna); end

  def calificar(pedido, calificacion, comentario)
    pedido.establecer_calificacion(calificacion, comentario)
  end

  def cancelar(_pedido)
    raise PedidoYaEntregado
  end
end

class EstadoPedidoCancelado < EstadoPedido
  ID_ESTADO_CANCELADO = 'cancelado'.freeze

  def initialize
    @id = ID_ESTADO_CANCELADO
  end

  def avanzar(_pedido, _la_nonna); end
end

class FabricaEstadosPedido
  ESTADOS = {'recibido': EstadoPedidoRecibido, 'en_preparacion': EstadoPedidoEnPreparacion, 'en_camino': EstadoPedidoEnCamino, 'entregado': EstadoPedidoEntregado,
             'en_espera': EstadoPedidoEnEspera, 'cancelado': EstadoPedidoCancelado}.freeze

  def self.fabricar(codigo_estado)
    codigo_estado = 'recibido' if codigo_estado.nil?
    ESTADOS[codigo_estado.to_sym].new
  end
end
