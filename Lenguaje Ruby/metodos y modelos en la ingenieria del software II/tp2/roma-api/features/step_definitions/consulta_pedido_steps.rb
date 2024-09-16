TIPO_DE_MENUS = {"Menu individual": '1', "Menu parejas": '2', "Menu familiar": '3'}.freeze

ID_ESTADOS = {'Recibido': 'recibido', 'En preparacion': 'en_preparacion', 'En camino': 'en_camino', 'Entregado': 'entregado', 'En espera': 'en_espera'}.freeze

CANTIDAD_PASOS_ESTADOS = {Recibido: 1, 'En preparacion': 2}.freeze

Dado('que tengo un pedido') do
  @usuario = {nombre_usuario: 'consulta_menu_1', nombre: 'tomas', direccion: 'Santa Fe 1024', telefono: '46857314'}
  registrar_usuario('consulta_menu_1', 'tomas', 'Cordoba 123', '75423453', ENV['LANONNA_API_KEY'])

  @respuesta = crear_pedido('1', 'consulta_menu_1')
  @id_pedido = JSON.parse(@respuesta.body)['id']
end

Dado('esta en estado {string}') do |estado|
  crear_repartidor('repartidor_estado01')
  i = 0
  estado_pedido = 'recibido'
  until (estado_pedido == ID_ESTADOS[estado.to_sym]) || (i > 4)
    r = avanzar_estado(@id_pedido)
    estado_pedido = JSON.parse(r.body)['estado']
    i += 1
  end
end

Dado('esta en estado En espera') do
  pedido_estado_en_espera(@id_pedido)
end

Cuando('consulto el estado del pedido') do
  @respuesta = consultar_estado_pedido(@id_pedido, @usuario[:nombre_usuario])
end

Entonces('veo el mensaje de estado {string}') do |estado|
  expect(JSON.parse(@respuesta.body)['estado']).to eq ID_ESTADOS[estado.to_sym]
end
