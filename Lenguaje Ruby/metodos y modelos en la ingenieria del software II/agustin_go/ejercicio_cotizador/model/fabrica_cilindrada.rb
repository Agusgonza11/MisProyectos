require_relative 'cilindrada.rb'
require_relative '../errors/cilindrada_invalida.rb'

class FabricaCilindrada
  def self.fabricar(cilindrada)
    case cilindrada
    when '1000'
      Cilindrada.new(1000)
    when '1600'
      Cilindrada.new(1600)
    when '2000'
      Cilindrada.new(2000)
    else
      raise CilindradaInvalida
    end
  end
end
