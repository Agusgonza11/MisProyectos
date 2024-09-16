require 'spec_helper'
require 'web_mock'
require "#{File.dirname(__FILE__)}/../lib/webapi"

USUARIO_CREAR = { 'nombre_usuario': '123123', 'nombre': 'Hernan', 'direccion': 'Paseo Colon 850', 'telefono': '555666' }.freeze
MENUS_OBTENER = [{ 'id': 1, 'nombre': 'Menu individual', 'precio': 100 },
                 { 'id': 2, 'nombre': 'Menu parejas', 'precio': 175 },
                 { 'id': 3, 'nombre': 'Menu familiar', 'precio': 250 }].freeze
PEDIDO = { 'id': 43, 'nombre': 'Menu individual', 'usuario': '3213141', 'estado': 'recibido' }.freeze
PEDIDO_CANCELADO = { 'id': 43, 'nombre': 'Menu individual', 'usuario': '3213141', 'estado': 'cancelado' }.freeze
CALIFICACION = { 'id': 43, 'calificacion': 5 }.freeze
CALIFICACION_CON_COMENTARIO = { 'id': 4341, 'calificacion': 3, 'comentario': 'llego en tiempo, todo OK!' }.freeze

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

def mock_post_api(respuesta, ruta, status = 200)
  stub_request(:post, 'http://webapp:3000' + ruta)
    .with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent' => 'Faraday v0.15.4',
        'Authorization' => ENV['LANONNA_API_KEY']
      }
    )
    .to_return(status: status, body: respuesta, headers: {})
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

describe WebApi do
  subject(:webapi) { described_class.new }

  let(:mensaje) { instance_double('mensaje', from: instance_double('from', id: '123123')) }

  it 'deberia enviar una solicitud de creacion usuario' do
    mock_post_api(USUARIO_CREAR.to_json, '/usuarios', 201)
    usuario = webapi.crear_usuario('123123', 'Hernan', 'direccion', '123')
    expect(usuario.nombre_usuario).to eq '123123'
    expect(usuario.nombre).to eq 'Hernan'
  end

  it 'deberia enviar una solicitud de menus' do
    mock_get_api(MENUS_OBTENER.to_json, '/menus')
    lista_menus = webapi.menus
    expect(lista_menus.length).to be > 0
    expect(lista_menus[0].id).to eq MENUS_OBTENER[0][:id]
    expect(lista_menus[0].nombre).to eq MENUS_OBTENER[0][:nombre]
  end

  it 'deberia enviar una solicitud de pedido de menu' do
    mock_post_api(PEDIDO.to_json, '/pedidos', 201)
    menu = webapi.pedir_menu('123123', '1')
    expect(menu.id).to eq PEDIDO[:id]
    expect(menu.nombre).to eq PEDIDO[:nombre]
    expect(menu.usuario).to eq PEDIDO[:usuario]
  end

  it 'deberia consultar un pedido' do
    mock_get_api(PEDIDO.to_json, '/pedidos/43?nombre_usuario=123123')
    pedido = webapi.consultar_pedido('123123', '43')
    expect(pedido.id).to eq PEDIDO[:id]
    expect(pedido.nombre).to eq PEDIDO[:nombre]
    expect(pedido.usuario).to eq PEDIDO[:usuario]
  end

  it 'deberia calificar un pedido' do
    mock_patch_api(CALIFICACION.to_json, '/pedidos/43')
    pedido_calificado = webapi.calificar_pedido('123123', '43', '5')
    expect(pedido_calificado.id).to eq CALIFICACION[:id]
    expect(pedido_calificado.calificacion).to eq CALIFICACION[:calificacion]
  end

  it 'deberia calificar un pedido con comentario' do
    mock_patch_api(CALIFICACION_CON_COMENTARIO.to_json, '/pedidos/4341')
    pedido_calificado = webapi.calificar_pedido('123123', '4341', '3', 'llego en tiempo, todo OK!')
    expect(pedido_calificado.id).to eq CALIFICACION_CON_COMENTARIO[:id]
    expect(pedido_calificado.calificacion).to eq CALIFICACION_CON_COMENTARIO[:calificacion]
    expect(pedido_calificado.comentario).to eq CALIFICACION_CON_COMENTARIO[:comentario]
  end

  it 'deberia cancelar un pedido' do
    mock_post_api(PEDIDO_CANCELADO.to_json, '/pedidos/43/estado/cancelado')
    pedido = webapi.cancelar_pedido('123123', '43')
    expect(pedido.usuario).to eq PEDIDO[:usuario]
    expect(pedido.estado).to eq 'cancelado'
  end
end
