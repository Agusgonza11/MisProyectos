Dado('que existe un repartidor Disponible') do
  @repartidor = crear_repartidor('repartidor_despachable1')
end

Dado('con Menu Individual') do
  registrar_usuario('usuario_despacho02', 'tomas', 'Cordoba 123', '75423453', ENV['LANONNA_API_KEY'])

  @respuesta = crear_pedido('1', 'usuario_despacho02')
  @id_pedido = JSON.parse(@respuesta.body)['id']
  pedido_estado_en_camino(@id_pedido)
end

Cuando('despacho el repartidor') do
  @respuesta = cambiar_estado_repartidor(JSON.parse(@repartidor.body)['id'])
end

Entonces('el repartidor esta en estado En Camino con {int} espacio ocupado') do |espacio_ocupado|
  expect(JSON.parse(@respuesta.body)['estado']).to eq 'en_camino'
  expect(JSON.parse(@respuesta.body)['espacio_ocupado']).to eq espacio_ocupado
end

Entonces('el repartidor esta en estado Disponible con {int} espacio ocupado') do |espacio_ocupado|
  expect(JSON.parse(@respuesta.body)['estado']).to eq 'disponible'
  expect(JSON.parse(@respuesta.body)['espacio_ocupado']).to eq espacio_ocupado
end
