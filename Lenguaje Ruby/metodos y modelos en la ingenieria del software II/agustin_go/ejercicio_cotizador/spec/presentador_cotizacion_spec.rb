require 'spec_helper'
require_relative '../lib/presentador_cotizacion.rb'


describe 'PresentadorCotizacion' do
  CODIGO_VEHICULO_INVALIDO = 'vehiculo_invalido'.freeze
  CODIGO_CILINDRADA_INVALIDA = 'cilindrada_invalida'.freeze
  CODIGO_KILOMETRAJE_INVALIDO = 'kilometraje_invalido'.freeze
  MENSAJE_VEHICULO_INVALIDO = 'El vehiculo ingresado es invalido'.freeze
  MENSAJE_CILINDRADA_INVALIDA = 'La cilindrada ingresada es invalida'.freeze
  MENSAJE_KILOMETRAJE_INVALIDO = 'El kilometraje ingresado es invalido'.freeze

  it 'presentar un resultado con coeficiente impositivo de 5 y valor de mercado de 2000.1546874 deberia mostrar el mensaje' do
    expect(PresentadorCotizacion.presentar([5, 2000.0546874])).to eq 'ci:5 & vm:2000.1'
  end

  it 'presentar un resultado con coeficiente impositivo de 10 y valor de mercado de 100 deberia mostrar el mensaje' do
    expect(PresentadorCotizacion.presentar([10, 100])).to eq 'ci:10 & vm:100.0'
  end

  it 'presentar un error con el codigo de vehiculo_invalido deberia devolver su mensaje de error' do
    expect(PresentadorCotizacion.presentar_error(CODIGO_VEHICULO_INVALIDO)).to eq MENSAJE_VEHICULO_INVALIDO
  end

  it 'presentar un error con el codigo de cilindrada_invalida deberia devolver su mensaje de error' do
    expect(PresentadorCotizacion.presentar_error(CODIGO_CILINDRADA_INVALIDA)).to eq MENSAJE_CILINDRADA_INVALIDA
  end

  it 'presentar un error con el codigo de kilometraje_invalido deberia devolver su mensaje de error' do
    expect(PresentadorCotizacion.presentar_error(CODIGO_KILOMETRAJE_INVALIDO)).to eq MENSAJE_KILOMETRAJE_INVALIDO
  end
end