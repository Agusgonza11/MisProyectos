Dado('que existe un pedido con estado {string}') do |_estado|
  @usuario = {nombre_usuario: 'consulta_estado_1', nombre: 'hernancito', direccion: 'Cordoba 123', telefono: '75423453'}
  registrar_usuario('consulta_estado_1', 'hernancito', 'Cordoba 123', '75423453', ENV['LANONNA_API_KEY'])
  @respuesta = crear_pedido('2', 'consulta_estado_1')
  @id_pedido = JSON.parse(@respuesta.body)['id']
end

Cuando('pedido empieza a cocinarse') do
  @respuesta = avanzar_estado(@id_pedido)
end

Entonces('el estado del pedido está en {string}') do |estado|
  expect(JSON.parse(@respuesta.body)['estado']).to eq ID_ESTADOS[estado.to_sym]
end
