Dado('que un usuario realizo un pedido') do
  @usuario = {nombre_usuario: 'validacion_calificacion_menu1', nombre: 'marcos', direccion: 'Santa Fe 458', telefono: '78951453'}
  registrar_usuario('validacion_calificacion_menu1', 'marcos', 'Cordoba 123', '75423453', ENV['LANONNA_API_KEY'])
  @respuesta = crear_pedido('1', 'validacion_calificacion_menu1')
  @id_pedido = JSON.parse(@respuesta.body)['id']
end

Dado('que el pedido esta en estado Recibido') do
end

Dado('que el pedido esta en estado En preparacion') do
  avanzar_estado(@id_pedido)
end

Dado('que el pedido esta en estado En espera') do
  pedido_estado_en_espera(@id_pedido)
end

Dado('que el pedido esta en estado En camino') do
  crear_repartidor('carlos_repartidor')
  pedido_estado_en_camino(@id_pedido)
end

Cuando('el usuario califica el pedido') do
  @respuesta = calificar_pedido(@id_pedido, 'validacion_calificacion_menu1', 4)
end

Entonces('recibe el mensaje de que no se puede calificar el pedido') do
  expect(@respuesta.status).to eq 409
end
