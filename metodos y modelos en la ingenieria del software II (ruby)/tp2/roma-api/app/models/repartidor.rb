class Repartidor
  attr_reader :nombre_usuario, :nombre, :pedidos, :estado, :espacio_ocupado
  attr_accessor :id

  def initialize(nombre_usuario, nombre, id = nil, espacio_ocupado = 0, estado = nil)
    @nombre_usuario = nombre_usuario
    @nombre = nombre
    @id = id
    @espacio_ocupado = espacio_ocupado
    @estado = estado
  end

  def self.crear(nombre_usuario, nombre)
    Repartidor.new(nombre_usuario, nombre, nil, 0, FabricaEstadosRepartidor.fabricar('disponible'))
  end

  def asignar_pedido(pedido)
    raise NoHayEspacio if @espacio_ocupado + pedido.volumen > 3

    @espacio_ocupado += pedido.volumen
    pedido.establecer_repartidor(self)
  end

  def entregar_pedido_con_volumen(volumen)
    @espacio_ocupado -= volumen
  end

  def avanzar_estado
    @estado.avanzar(self, espacio_ocupado)
  end

  def establecer_estado(estado)
    @estado = estado
  end
end
