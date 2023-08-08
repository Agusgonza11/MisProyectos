class ConsultaRestringida < StandardError
  def initialize
    super('consulta_restringida')
  end
end
