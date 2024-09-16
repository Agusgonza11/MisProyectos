Dado('que tengo pendiente {int} pedido entregado por calificar') do |pedidos_pendientes|
  @pedidos_pendientes = pedidos_pendientes
  crear_repartidor('hernan_123')
  @usuario = {nombre_usuario: 'pedirMenu01', nombre: 'tomas', direccion: 'Santa Fe 1024', telefono: '46857314'}
  registrar_usuario('pedirMenu01', 'tomas', 'Santa Fe 1024', '46857314', ENV['LANONNA_API_KEY'])
  pedidos = []
  @pedidos_pendientes.times do
    pedidos << crear_pedido('1', 'pedirMenu01')
  end
  pedidos.each do |pedido|
    pedido_estado_entregado(JSON.parse(pedido.body)['id'])
  end
end

Entonces('veo el mensaje de pedido pendiente por calificar') do
  expect(@respuesta.status).to eq 409
end

Entonces('me muestra el pedido pendiente por calificar') do
  expect(JSON.parse(@respuesta.body)['pedidos'].size).to eq @pedidos_pendientes
end

Entonces('me muestra los pedidos pendientes por calificar') do
  expect(JSON.parse(@respuesta.body)['pedidos'].size).to eq @pedidos_pendientes
end
