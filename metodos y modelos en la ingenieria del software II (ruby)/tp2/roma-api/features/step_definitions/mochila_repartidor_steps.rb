Dado('que el repartidor esta sin menus asignados') do
  @repartidor = crear_repartidor('hernan_mochila')

  @usuario = {nombre_usuario: 'usuario_mochila01', nombre: 'tomas', direccion: 'Santa Fe 1024', telefono: '46857314'}
  registrar_usuario('usuario_mochila01', 'tomas', 'Cordoba 123', '75423453', ENV['LANONNA_API_KEY'])
end

Dado('que el repartidor tiene un Menu Individual asignado') do
  @repartidor = crear_repartidor('hernan_mochila02')

  @usuario = {nombre_usuario: 'usuario_mochila02', nombre: 'tomas', direccion: 'Santa Fe 1024', telefono: '46857314'}
  registrar_usuario('usuario_mochila02', 'tomas', 'Cordoba 123', '75423453', ENV['LANONNA_API_KEY'])

  @respuesta = crear_pedido('1', @usuario[:nombre_usuario])
  @id_pedido = JSON.parse(@respuesta.body)['id']
  pedido_estado_en_camino(@id_pedido)
end

Cuando('agrego un pedido Menu Individual') do
  @respuesta = crear_pedido('1', @usuario[:nombre_usuario])
  @id_pedido = JSON.parse(@respuesta.body)['id']
  @respuesta = pedido_estado_en_camino(@id_pedido)
end

Cuando('agrego un pedido Menu Parejas') do
  @respuesta = crear_pedido('2', @usuario[:nombre_usuario])
  @id_pedido = JSON.parse(@respuesta.body)['id']
  @respuesta = pedido_estado_en_camino(@id_pedido)
end

Cuando('agrego un pedido Menu Familiar') do
  @respuesta = crear_pedido('3', @usuario[:nombre_usuario])
  @id_pedido = JSON.parse(@respuesta.body)['id']
  @respuesta = pedido_estado_en_camino(@id_pedido)
end

Entonces('el repartidor tiene {int} de espacio ocupado') do |espacio_ocupado|
  repartidor_repo = Persistence::Repositories::RepartidorRepositorio.new
  expect(repartidor_repo.find(JSON.parse(@repartidor.body)['id']).espacio_ocupado).to eq espacio_ocupado
end

Entonces('el pedido no pudo ser asignado al repartidor') do
  expect(JSON.parse(@respuesta.body)['estado']).to eq 'en_espera'
end
