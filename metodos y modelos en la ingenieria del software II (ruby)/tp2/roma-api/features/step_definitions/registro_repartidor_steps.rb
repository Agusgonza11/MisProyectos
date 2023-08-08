Cuando('registro un repartidor con el nombre de usuario {string}') do |nombre_usuario|
  @nombre_usuario = nombre_usuario
end

Cuando('con nombre {string}') do |nombre|
  @repartidor = crear_repartidor(@nombre_usuario, nombre)
end

Entonces('veo la creacion correcta de {string} con nombre de usuario {string}') do |nombre, nombre_usuario|
  expect(JSON.parse(@repartidor.body)['nombre']).to eq nombre
  expect(JSON.parse(@repartidor.body)['nombre_usuario']).to eq nombre_usuario
end
