class CalculadorAlquilerCuit
  def calcular_importe(cuit, precio_base)
    resultado = precio_base
    if cuit[0] == '2' && cuit[1] == '6' && resultado != 0
      descuento = resultado * 5 / 100
      resultado -= descuento
    end
    resultado
  end
end
