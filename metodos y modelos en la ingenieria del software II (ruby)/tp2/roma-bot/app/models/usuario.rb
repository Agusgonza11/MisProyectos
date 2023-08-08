class Usuario
  attr_reader :nombre_usuario, :nombre

  def initialize(nombre_usuario, nombre)
    @nombre_usuario = nombre_usuario
    @nombre = nombre
  end
end
