require 'spec_helper'
# rubocop:disable RSpec/ExampleLength

BIENVENIDO_HERNAN_INTEGRACION = 'Bienvenido Hernan, tu id de usuario es 141733544.'.freeze
PEDIDO_INDIVIDUAL_RESPUESTA_INTEGRACION = 'Tu pedido de Menu individual fue recibido con exito. Tu numero de pedido es 1'.freeze
CANCELACION_PEDIDO_RESPUESTA_INTEGRACION = 'Tu pedido de Menu individual con id 1 fue cancelado con exito.'.freeze

describe 'integracion API' do
  it 'deberia devolver los menus disponibles al hacer /menus' do
    if ENV['INTEGRACION']
      when_i_send_text('fake_token', '/menus')
      then_i_get_text('fake_token', MENU_RESPUESTA_SPEC)
      BotClient.new('fake_token').run_once
    else
      true
    end
  end

  it 'deberia registrarme con /registrarse Hernan, Paseo Colon 850, 555666' do
    if ENV['INTEGRACION']
      when_i_send_text('fake_token', '/registrarse Hernan, Paseo Colon 850, 555666')
      then_i_get_text('fake_token', BIENVENIDO_HERNAN_INTEGRACION)
      BotClient.new('fake_token').run_once
    else
      true
    end
  end

  it 'deberia pedir un menu con /pedir y el numero del menu' do
    if ENV['INTEGRACION']
      when_i_send_text('fake_token', '/pedir 1')
      then_i_get_text('fake_token', PEDIDO_INDIVIDUAL_RESPUESTA_INTEGRACION)
      BotClient.new('fake_token').run_once
    else
      true
    end
  end

  it 'deberia cancelar un pedido con /cancelar y el id del pedido' do
    if ENV['INTEGRACION']
      when_i_send_text('fake_token', '/cancelar 1')
      then_i_get_text('fake_token', CANCELACION_PEDIDO_RESPUESTA_INTEGRACION)
      BotClient.new('fake_token').run_once
    else
      true
    end
  end
end
# rubocop:enable RSpec/ExampleLength
