class Chopper
  def initialize
    @buscador = Buscador.new
    @sumador = Sumador.new
  end

  def chop(position, array)
    @buscador.encontrar(position, array)
  end

  def sum(array)
    @sumador.sumar(array)
  end
end
