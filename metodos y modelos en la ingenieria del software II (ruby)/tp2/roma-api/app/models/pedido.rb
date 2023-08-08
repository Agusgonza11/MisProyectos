class Pedido
  attr_accessor :id
  attr_reader :nombre_menu, :estado, :precio, :usuario, :repartidor, :calificacion, :comentario, :volumen, :fecha, :clima

  CALIFICACIONES = [1, 2, 3, 4, 5].freeze

  def initialize(nombre_menu, estado, usuario, precio, volumen, id = nil, repartidor = nil, calificacion = nil, comentario = nil, fecha = nil, clima = nil)
    @nombre_menu = nombre_menu
    @estado = estado
    @id = id
    @usuario = usuario
    @repartidor = repartidor
    @precio = precio
    @calificacion = calificacion
    @comentario = comentario
    @volumen = volumen
    @fecha = fecha
    @clima = clima
  end

  def self.crear(nombre_menu, estado, usuario, precio, volumen, fecha, api_clima)
    Pedido.new(nombre_menu, estado, usuario, precio, volumen, nil, nil, nil, nil, fecha.hoy, api_clima.clima(fecha.hoy))
  end

  def avanzar_estado(la_nonna)
    @estado.avanzar(self, la_nonna)
  end

  def establecer_estado(estado)
    @estado = estado
  end

  def establecer_repartidor(repartidor)
    @repartidor = repartidor
  end

  def obtener_comision(contador)
    contador.calcular_comision(@precio, @calificacion, @clima || '')
  end

  def calificar(usuario, calificacion, comentario = nil)
    raise ValorDeCalificacionInvalido unless CALIFICACIONES.include? calificacion
    raise CalificacionRestringida if @usuario != usuario
    raise PedidoYaCalificado unless @calificacion.nil?

    @estado.calificar(self, calificacion, comentario)
  end

  def entregar
    @repartidor.entregar_pedido_con_volumen(@volumen)
  end

  def establecer_calificacion(calificacion, comentario)
    @calificacion = calificacion
    @comentario = comentario
  end

  def consultar(usuario)
    raise ConsultaRestringida if @usuario != usuario

    self
  end

  def cancelar(usuario)
    raise CancelacionRestringida if @usuario != usuario

    @estado.cancelar(self)
  end
end
