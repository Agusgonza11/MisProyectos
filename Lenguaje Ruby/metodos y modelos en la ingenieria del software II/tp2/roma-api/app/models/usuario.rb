class Usuario
  attr_reader :nombre_usuario, :nombre, :direccion, :telefono
  attr_accessor :id

  def initialize(nombre_usuario, nombre, direccion, telefono, id = nil)
    @id = id
    @nombre_usuario = nombre_usuario
    @nombre = nombre
    @direccion = direccion
    @telefono = telefono
  end

  def !=(other)
    return true if other.nil?

    @id != other.id
  end
end
