class PresentadorCotizacion
  CODIGO_VEHICULO_INVALIDO = 'vehiculo_invalido'.freeze
  CODIGO_CILINDRADA_INVALIDA = 'cilindrada_invalida'.freeze
  CODIGO_KILOMETRAJE_INVALIDO = 'kilometraje_invalido'.freeze
  MENSAJE_VEHICULO_INVALIDO = 'El vehiculo ingresado es invalido'.freeze
  MENSAJE_CILINDRADA_INVALIDA = 'La cilindrada ingresada es invalida'.freeze
  MENSAJE_KILOMETRAJE_INVALIDO = 'El kilometraje ingresado es invalido'.freeze

  def self.presentar(resultado)
    'ci:' + resultado[0].to_s + ' & vm:' + resultado[1].to_f.round(1).to_s
  end

  def self.presentar_error(error)
    case error.to_s
    when CODIGO_VEHICULO_INVALIDO
      MENSAJE_VEHICULO_INVALIDO
    when CODIGO_CILINDRADA_INVALIDA
      MENSAJE_CILINDRADA_INVALIDA
    when CODIGO_KILOMETRAJE_INVALIDO
      MENSAJE_KILOMETRAJE_INVALIDO
    end
  end
end
