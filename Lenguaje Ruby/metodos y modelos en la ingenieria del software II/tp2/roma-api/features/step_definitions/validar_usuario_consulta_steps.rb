Dado('que existe un pedido del usuario {string}') do |nombre_usuario|
  @usuario = {nombre_usuario: nombre_usuario, nombre: 'marcos', direccion: 'Santa Fe 458', telefono: '78951453'}
  registrar_usuario(nombre_usuario, 'marcos', 'Cordoba 123', '75423453', ENV['LANONNA_API_KEY'])
  @respuesta = crear_pedido('3', nombre_usuario)
  @id_pedido = JSON.parse(@respuesta.body)['id']
end

Cuando('el usuario {string} consulta el pedido') do |otro_usuario|
  @usuario = {nombre_usuario: otro_usuario, nombre: 'marcos_falso', direccion: 'Calle falsa 123', telefono: '12345678'}
  registrar_usuario(otro_usuario, 'marcos_falso', 'Calle falsa 123', '12345678', ENV['LANONNA_API_KEY'])
  @respuesta = consultar_estado_pedido(@id_pedido, otro_usuario)
end

Entonces('se recibe el mensaje de {string}') do |_mensaje_error|
  expect(@respuesta.status).to eq 403
end
