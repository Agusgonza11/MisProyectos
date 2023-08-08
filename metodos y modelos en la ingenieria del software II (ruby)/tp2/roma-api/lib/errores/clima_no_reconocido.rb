class ClimaNoReconocido < StandardError
  def initialize
    super('clima_no_reconocido')
  end
end
