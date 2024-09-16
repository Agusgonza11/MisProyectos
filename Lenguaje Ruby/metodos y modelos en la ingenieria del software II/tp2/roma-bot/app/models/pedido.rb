class Pedido
  attr_reader :id, :nombre, :usuario, :estado, :calificacion, :comentario

  # rubocop:disable Metrics/ParameterLists
  def initialize(id, nombre, usuario, estado, calificacion = nil, comentario = nil)
    @id = id
    @nombre = nombre
    @usuario = usuario
    @estado = estado
    @calificacion = calificacion
    @comentario = comentario
  end
  # rubocop:enable Metrics/ParameterLists
end
