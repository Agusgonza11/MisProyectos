require_relative 'calculador_tipo_alquiler.rb'
require_relative 'calculador_cuit.rb'
require_relative 'calculador_tiempo.rb'

class App
  def calcular_importe(tipo, parametros, cuit, fecha_alquiler, fecha_devolucion)
    calculador_tipo = CalculadorAlquilerTipo.new
    calculador_cuit = CalculadorAlquilerCuit.new
    calculador_tiempo = CalculadorAlquilerTiempo.new
    precio_base = calculador_tipo.calcular_importe(tipo, parametros)
    precio = calculador_cuit.calcular_importe(cuit, precio_base)
    calculador_tiempo.calcular_importe(fecha_alquiler, fecha_devolucion, tipo, parametros, precio)
  end

  def main
    importe = calcular_importe(ARGV[3], ARGV[4], ARGV[2], ARGV[0], ARGV[1])
    puts 'importe: ' + importe.to_s
  end
end

if __FILE__ == $PROGRAM_NAME
  app = App.new
  app.main
end
