require_relative 'model/fabrica_vehiculos.rb'
require_relative 'model/fabrica_cilindrada.rb'
require_relative 'lib/presentador_cotizacion.rb'

arg = ARGV[0].split('/')

begin
  vehiculo = FabricaVehiculos.fabricar(arg[0])
  cilindrada = FabricaCilindrada.fabricar(arg[1])

  cotizacion = vehiculo.cotizar(cilindrada, arg[2].to_i)

  puts PresentadorCotizacion.presentar(cotizacion)
rescue StandardError => e
  puts PresentadorCotizacion.presentar_error(e)
end
