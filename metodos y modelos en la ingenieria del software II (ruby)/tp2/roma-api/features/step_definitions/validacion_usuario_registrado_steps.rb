Dado('que no tengo usuario registrado para {string}') do |_usuario|
end

Cuando('pide un menu') do
  @respuesta = crear_pedido('3', 'usuario_no_existente')
end

Entonces('se recibe el mensaje de error') do
  expect(@respuesta.status).to eq 403
  expect(JSON.parse(@respuesta.body)['error']).to eq 'usuario_no_registrado'
end
