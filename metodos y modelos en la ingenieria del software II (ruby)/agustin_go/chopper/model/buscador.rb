class Buscador
  def encontrar(position, array)
    array.each_with_index do |elemento, posicion|
      return posicion if elemento == position
    end
    return -1 if array.empty?
  end
end
