Dado('que existe un pedido con estado En camino') do
  @usuario = {nombre_usuario: 'usuario_entrega', nombre: 'hernancito', direccion: 'Cordoba 123', telefono: '75423453'}
  registrar_usuario('usuario_entrega', 'hernancito', 'Cordoba 123', '75423453', ENV['LANONNA_API_KEY'])

  @repartidor = crear_repartidor('hernan_repartidor_entrega')

  @respuesta = crear_pedido('2', 'usuario_entrega')
  @id_pedido = JSON.parse(@respuesta.body)['id']

  pedido_estado_en_camino(@id_pedido)
end

Cuando('el pedido es entregado') do
  @respuesta = avanzar_estado(@id_pedido)
end
