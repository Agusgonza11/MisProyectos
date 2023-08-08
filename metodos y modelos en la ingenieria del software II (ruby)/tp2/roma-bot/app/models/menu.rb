class Menu
  attr_reader :id, :nombre, :precio

  def initialize(id, nombre, precio)
    @id = id
    @nombre = nombre
    @precio = precio
  end
end
