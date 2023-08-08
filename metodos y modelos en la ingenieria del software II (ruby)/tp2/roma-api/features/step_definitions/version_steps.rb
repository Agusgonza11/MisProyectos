Cuando(/^obtengo la version de la app$/) do
  @respuesta = Faraday.get("#{BASE_URL}/")
end

Entonces(/^el equipo es "([^"]*)"$/) do |equipo|
  expect(@respuesta.status).to eq(200)
  version = @respuesta.body
  expect(version).to match(/#{equipo}/)
end

Entonces(/^la version esta actualizada$/) do
  expect(@respuesta.status).to eq(200)
  version = @respuesta.body
  expect(version).to match(/#{Version.current}/)
end
