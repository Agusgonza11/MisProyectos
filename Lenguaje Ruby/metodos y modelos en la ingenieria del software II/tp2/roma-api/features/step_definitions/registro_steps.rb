Cuando(/^me registro con el nombre "([^"]*)"$/) do |nombre|
  @nombre = nombre
end

Cuando(/^dirección "([^"]*)"$/) do |direccion|
  @direccion = direccion
end

Cuando(/^teléfono "([^"]*)"$/) do |telefono|
  @telefono = telefono
  @usuario = registrar_usuario('u1', @nombre, @direccion, @telefono, ENV['LANONNA_API_KEY'])
end

Entonces(/^veo el mensaje de bienvenida a "([^"]*)"$/) do |nombre|
  expect(JSON.parse(@usuario.body)['nombre']).to eq nombre
end
