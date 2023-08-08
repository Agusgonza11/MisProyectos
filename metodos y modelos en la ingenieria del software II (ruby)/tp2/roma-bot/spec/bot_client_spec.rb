require 'spec_helper'
require 'web_mock'

require "#{File.dirname(__FILE__)}/../app/bot_client"

require_relative '../lib/team.rb'

MENUS_ESPERADOS_SPEC = [{ 'id': 1, 'nombre': 'Menu individual', 'precio': 100 },
                        { 'id': 2, 'nombre': 'Menu parejas', 'precio': 175 },
                        { 'id': 3, 'nombre': 'Menu familiar', 'precio': 250 }].freeze
MENU_RESPUESTA_SPEC = "1-Menu individual ($100)\n2-Menu parejas ($175)\n3-Menu familiar ($250)".freeze
PEDIDO_INDIVIDUAL_ESPERADO_SPEC = { 'id': 43, 'nombre': 'Menu individual', 'usuario': '3213141', 'estado': 'recibido' }.freeze
PEDIDO_INDIVIDUAL_RESPUESTA_SPEC = 'Tu pedido de Menu individual fue recibido con exito. Tu numero de pedido es 43'.freeze
USUARIO_HERNAN_SPEC = { 'nombre_usuario': 'u1', 'nombre': 'Hernan', 'direccion': 'Paseo Colon 850', 'telefono': '555666' }.freeze
BIENVENIDO_HERNAN_SPEC = 'Bienvenido Hernan, tu id de usuario es u1.'.freeze
PEDIDO_ESPERADO_SPEC = { 'id': 142, 'nombre': 'Menu individual', 'usuario': '3213141', 'estado': 'recibido' }.freeze
PEDIDO_ESTADO_RESPUESTA_SPEC = 'El pedido 142 esta en estado Recibido.'.freeze
CALIFICACION_PEDIDO_SPEC = { 'id': 142, 'calificacion': 5 }.freeze
CALIFICACION_RESPUESTA_SPEC = 'Tu pedido con id 142 fue calificado con 5.'.freeze
CALIFICACION_PEDIDO_CON_COMENTARIO_SPEC = { 'id': 14_252, 'calificacion': 1, 'comentario': 'estuvo feo' }.freeze
CALIFICACION_CON_COMENTARIO_RESPUESTA_SPEC = 'Tu pedido con id 14252 fue calificado con 1 y el comentario "estuvo feo".'.freeze
CANCELACION_PEDIDO_SPEC = { 'id': 54_321, 'nombre': 'Menu parejas', 'usuario': '3141653', 'estado': 'cancelado' }.freeze
CANCELACION_PEDIDO_RESPUESTA_SPEC = 'Tu pedido de Menu parejas con id 54321 fue cancelado con exito.'.freeze

def when_i_send_text(token, message_text)
  body = { "ok": true, "result": [{ "update_id": 693_981_718,
                                    "message": { "message_id": 11,
                                                 "from": { "id": 141_733_544, "is_bot": false, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "language_code": 'en' },
                                                 "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                                                 "date": 1_557_782_998, "text": message_text,
                                                 "entities": [{ "offset": 0, "length": 6, "type": 'bot_command' }] } }] }

  stub_request(:any, "https://api.telegram.org/bot#{token}/getUpdates")
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def then_i_get_text(token, message_text)
  body = { "ok": true,
           "result": { "message_id": 12,
                       "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
                       "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                       "date": 1_557_782_999, "text": message_text } }

  stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
    .with(
      body: { 'chat_id' => '141733544', 'text' => message_text }
    )
    .to_return(status: 200, body: body.to_json, headers: {})
end

def mock_get_api(respuesta, ruta)
  stub_request(:get, 'http://webapp:3000' + ruta)
    .with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent' => 'Faraday v0.15.4',
        'Authorization' => ENV['LANONNA_API_KEY']
      }
    )
    .to_return(status: 200, body: respuesta, headers: {})
end

def mock_patch_api(respuesta, ruta)
  stub_request(:patch, 'http://webapp:3000' + ruta)
    .with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent' => 'Faraday v0.15.4',
        'Authorization' => ENV['LANONNA_API_KEY']
      }
    )
    .to_return(status: 200, body: respuesta, headers: {})
end

describe 'BotClient' do
  it 'should get a /version message and respond with current version' do
    token = 'fake_token'

    when_i_send_text(token, '/version')
    then_i_get_text(token, Version.current)

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /start message and respond with Hola' do
    token = 'fake_token'

    when_i_send_text(token, '/start')
    then_i_get_text(token, 'Hola, Emilio')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /stop message and respond with Chau' do
    token = 'fake_token'

    when_i_send_text(token, '/stop')
    then_i_get_text(token, 'Chau, egutter')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get an unknown message message and respond with Do not understand' do
    token = 'fake_token'

    when_i_send_text(token, '/unknown')
    then_i_get_text(token, 'Uh? No te entiendo! Me repetis la pregunta?')

    app = BotClient.new(token)

    app.run_once
  end

  it 'deberia consultar /equipo y obtener el nombre del equipo ' do
    token = 'fake_token'

    when_i_send_text(token, '/equipo')
    then_i_get_text(token, Team.name)

    app = BotClient.new(token)

    app.run_once
  end

  it 'deberia consultar /version-api y obtener la version de la api ' do
    token = 'fake_token'

    mock_get_api('Roma', '/')

    when_i_send_text(token, '/version-api')
    then_i_get_text(token, 'Roma')

    BotClient.new(token).run_once
  end

  it 'deberia consultar /menus y obtener el listado de menus con sus precios' do
    mock_get_api(MENUS_ESPERADOS_SPEC.to_json, '/menus')
    when_i_send_text('fake_token', '/menus')
    then_i_get_text('fake_token', MENU_RESPUESTA_SPEC)
    BotClient.new('fake_token').run_once
  end

  it 'deberia registrarme con /registrarse Hernan, Paseo Colon 850, 555666' do
    mock_post_api(USUARIO_HERNAN_SPEC.to_json, '/usuarios', 201)
    when_i_send_text('fake_token', '/registrarse Hernan, Paseo Colon 850, 555666')
    then_i_get_text('fake_token', BIENVENIDO_HERNAN_SPEC)
    BotClient.new('fake_token').run_once
  end

  it 'deberia pedir un menu con /pedir y el numero del menu' do
    mock_post_api(PEDIDO_INDIVIDUAL_ESPERADO_SPEC.to_json, '/pedidos', 201)
    when_i_send_text('fake_token', '/pedir 1')
    then_i_get_text('fake_token', PEDIDO_INDIVIDUAL_RESPUESTA_SPEC)
    BotClient.new('fake_token').run_once
  end

  it 'deberia consultar un pedido con /consultar y el numero del pedido' do
    mock_get_api(PEDIDO_ESPERADO_SPEC.to_json, '/pedidos/142?nombre_usuario=141733544')
    when_i_send_text('fake_token', '/consultar 142')
    then_i_get_text('fake_token', PEDIDO_ESTADO_RESPUESTA_SPEC)
    BotClient.new('fake_token').run_once
  end

  it 'deberia calificar un pedido con /calificar el numero del pedido y la calificacion' do
    mock_patch_api(CALIFICACION_PEDIDO_SPEC.to_json, '/pedidos/142')
    when_i_send_text('fake_token', '/calificar 142, 5')
    then_i_get_text('fake_token', CALIFICACION_RESPUESTA_SPEC)
    BotClient.new('fake_token').run_once
  end

  it 'deberia calificar un pedido con /calificar el numero del pedido, la calificacion y un comentario' do
    mock_patch_api(CALIFICACION_PEDIDO_CON_COMENTARIO_SPEC.to_json, '/pedidos/14252')
    when_i_send_text('fake_token', '/calificar 14252, 1, estuvo feo')
    then_i_get_text('fake_token', CALIFICACION_CON_COMENTARIO_RESPUESTA_SPEC)
    BotClient.new('fake_token').run_once
  end

  it 'deberia cancelar un pedido con /cancelar y el id del pedido' do
    mock_post_api(CANCELACION_PEDIDO_SPEC.to_json, '/pedidos/54321/estado/cancelado')
    when_i_send_text('fake_token', '/cancelar 54321')
    then_i_get_text('fake_token', CANCELACION_PEDIDO_RESPUESTA_SPEC)
    BotClient.new('fake_token').run_once
  end
end
