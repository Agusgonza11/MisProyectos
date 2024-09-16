class Sumador
  def convertir_suma_doble_digito(suma_final)
    resultados = []
    suma_string = suma_final.to_s
    suma_string.split('').each do |numero|
      resultados.append(numero.to_i)
    end
    resultados
  end

  def sumar(array)
    return 'vacio' if array.empty?

    resultados = %w[cero uno dos tres cuatro cinco seis siete ocho nueve]
    sumador = 0
    array.each do |numero|
      sumador += numero
    end
    return 'demasiado grande' if sumador > 99

    if sumador > 9
      suma_convertida = convertir_suma_doble_digito(sumador)
      return resultados[suma_convertida[0]] + ',' + resultados[suma_convertida[1]]
    end
    resultados[sumador]
  end
end
