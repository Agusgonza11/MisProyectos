Dado('que no estoy autenticado') do
  @token = 'fake_token'
end

Cuando('quiero registrarme') do
  @respuesta = registrar_usuario('hernan', 'superhernan', 'casa de hernan', 'telefono de hernan', @token)
end

Entonces('recibe un error por no estar autorizado') do
  expect(@respuesta.status).to eq 401
  expect(JSON.parse(@respuesta.body)['error']).to eq 'solicitud_no_autorizada'
end

Dado('que estoy autenticado') do
  @token = ENV['LANONNA_API_KEY']
end

Entonces('recibe un mensaje de registracion exitosa') do
  expect(@respuesta.status).to eq 201
  expect(JSON.parse(@respuesta.body)['nombre']).to eq 'superhernan'
end
