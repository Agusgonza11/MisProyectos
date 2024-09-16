Dado('que realice un pedido') do
  @usuario = {nombre_usuario: 'calificacion_menu1', nombre: 'marcos', direccion: 'Santa Fe 458', telefono: '78951453'}
  registrar_usuario('calificacion_menu1', 'marcos', 'Santa Fe 458', '78951453', ENV['LANONNA_API_KEY'])
  @respuesta = crear_pedido('1', 'calificacion_menu1')
  @id_pedido = JSON.parse(@respuesta.body)['id']
end

Dado('que mi pedido esta en estado Entregado') do
  crear_repartidor('carlos_repartidor')
  pedido_estado_entregado(@id_pedido)
end

Cuando('califico mi pedido con calificacion {int}') do |calificacion|
  @respuesta = calificar_pedido(@id_pedido, 'calificacion_menu1', calificacion)
end

Entonces('recibo el mensaje de calificacion de pedido con calificacion {int}') do |calificacion|
  expect(JSON.parse(@respuesta.body)['calificacion']).to eq calificacion
end

Cuando('lo intento calificar nuevamente con calificacion {int}') do |calificacion|
  @respuesta = calificar_pedido(@id_pedido, 'calificacion_menu1', calificacion)
end

Entonces('recibo el mensaje de que el pedido ya esta calificado') do
  expect(@respuesta.status).to eq 409
end
