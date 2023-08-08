require_relative 'vehiculo.rb'
require_relative '../errors/vehiculo_invalido.rb'

class FabricaVehiculos
  def self.fabricar(vehiculo)
    case vehiculo
    when 'auto'
      Auto.new
    when 'camioneta'
      Camioneta.new
    when 'camion'
      Camion.new
    else
      raise VehiculoInvalido
    end
  end
end
