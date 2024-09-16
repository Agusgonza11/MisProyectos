class AutorizacionInvalida < StandardError
  def initialize
    super('solicitud_no_autorizada')
  end
end

module WebTemplate
  class App
    module AutorizacionHelper
      def autorizar(headers)
        token = headers['Authorization']
        token = headers['HTTP_AUTHORIZATION'] if token.nil?
        raise AutorizacionInvalida if token != ENV['LANONNA_API_KEY']
      end
    end
    helpers AutorizacionHelper
  end
end
