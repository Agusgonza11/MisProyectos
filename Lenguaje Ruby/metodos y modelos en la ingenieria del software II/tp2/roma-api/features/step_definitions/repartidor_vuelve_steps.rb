Dado('que existe un repartidor en camino con un pedido de menu individual') do
  @repartidor = crear_repartidor('repartidor_vuelve1')

  usuario = {nombre_usuario: 'usuario_despacho02', nombre: 'tomas', direccion: 'Santa Fe 1024', telefono: '46857314'}
  registrar_usuario('usuario_despacho02', 'tomas', 'Cordoba 123', '75423453', ENV['LANONNA_API_KEY'])

  @respuesta = crear_pedido('1', usuario[:nombre_usuario])
  @id_pedido = JSON.parse(@respuesta.body)['id']
  pedido_estado_en_camino(@id_pedido)
  cambiar_estado_repartidor(JSON.parse(@repartidor.body)['id'])
end

Cuando('el repartidor quiere regresar al local sin entregar el pedido') do
  @respuesta = cambiar_estado_repartidor(JSON.parse(@repartidor.body)['id'])
end
