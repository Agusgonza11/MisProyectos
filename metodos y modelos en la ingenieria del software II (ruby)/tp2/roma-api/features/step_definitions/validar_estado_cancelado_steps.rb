Dado('que existe un pedido recibido del usuario {string}') do |nombre_usuario|
  @repartidor = crear_repartidor('hernan_repartidor')

  @usuario = {nombre_usuario: nombre_usuario, nombre: 'marcos', direccion: 'Santa Fe 458', telefono: '78951453'}
  registrar_usuario(nombre_usuario, 'marcos', 'Cordoba 123', '75423453', ENV['LANONNA_API_KEY'])
  respuesta = crear_pedido('3', nombre_usuario)
  @id_pedido = JSON.parse(respuesta.body)['id']
end

Cuando('el usuario {string} cancela el pedido') do |nombre_usuario|
  @respuesta = cancelar_pedido(@id_pedido, nombre_usuario)
end
