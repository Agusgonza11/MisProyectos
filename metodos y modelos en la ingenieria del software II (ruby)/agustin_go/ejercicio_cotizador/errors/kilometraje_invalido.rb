class KilometrajeInvalido < StandardError
  def initialize
    super('kilometraje_invalido')
  end
end
