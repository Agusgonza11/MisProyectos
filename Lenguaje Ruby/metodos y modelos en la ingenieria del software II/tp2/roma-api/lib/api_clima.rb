require 'faraday'
require 'json'

class ApiClima
  include Singleton

  CLIMA_API_REAL = 'real'.freeze
  CLIMA_SOLEADO = 'soleado'.freeze
  CLIMA_LLUVIOSO = 'lluvioso'.freeze

  def initialize
    @clima = ClimaReal.new
  end

  def self.setear_clima(clima)
    case clima
    when CLIMA_LLUVIOSO
      ApiClima.mockear_lluvioso
    when CLIMA_SOLEADO
      ApiClima.mockear_soleado
    when CLIMA_API_REAL
      ApiClima.clima_real
    else
      raise ClimaNoReconocido
    end
  end

  def self.mockear_soleado
    ApiClima.instance.establecer_clima(ClimaSoleado.new)
  end

  def self.mockear_lluvioso
    ApiClima.instance.establecer_clima(ClimaLluvioso.new)
  end

  def self.clima_real
    ApiClima.instance.establecer_clima(ClimaReal.new)
  end

  def clima(fecha)
    @clima.obtener_clima(fecha)
  end

  def establecer_clima(clima)
    @clima = clima
  end
end

class ClimaSoleado
  def obtener_clima(_fecha)
    'sunny'
  end
end

class ClimaLluvioso
  def obtener_clima(_fecha)
    'rain'
  end
end

class ClimaReal
  LATITUD_BUENOS_AIRES = '-34.60376'.freeze
  LONGITUD_BUENOS_AIRES = '-58.38162'.freeze
  URI_CLIMA_API = 'https://api.weatherapi.com/v1/history.json'.freeze
  HORA_DEFAULT = '12'.freeze

  def obtener_clima(fecha)
    clima = Faraday.get("#{URI_CLIMA_API}?key=#{ENV['CLIMA_API_KEY']}&q=#{LATITUD_BUENOS_AIRES},#{LONGITUD_BUENOS_AIRES}&dt=#{fecha}&hour=#{HORA_DEFAULT}")
    logger.debug "clima status #{clima.status}"
    logger.debug "clima body #{clima.body}"
    raise SolicitudClimaError if clima.status != 200

    JSON.parse(clima.body)['forecast']['forecastday'][0]['day']['condition']['text'].downcase
  end
end
