class CancelacionRestringida < StandardError
  def initialize
    super('cancelacion_restringida')
  end
end
