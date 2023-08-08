class VehiculoInvalido < StandardError
  def initialize
    super('vehiculo_invalido')
  end
end
