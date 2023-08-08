Dado('un {string} con {int} cilindradas y {int} kilometros') do |vehiculo, cilindradas, kilometros|
  @vehiculo = vehiculo
  @cilindradas = cilindradas
  @kilometros = kilometros
end

Dado('una {string} con {int} cilindradas y {int} kilometros') do |vehiculo, cilindradas, kilometros|
  @vehiculo = vehiculo
  @cilindradas = cilindradas
  @kilometros = kilometros
end

Cuando('lo cotizo') do
  @respuesta = `ruby app.rb "#{@vehiculo}"/"#{@cilindradas}"/"#{@kilometros}"`
end

Entonces('su coeficiente impositivo es {int} y su valor de mercado es {float}') do |coeficiente, vm|
  expect(@respuesta.strip).to eq 'ci:' + coeficiente.to_s + ' & vm:' + vm.to_s
end
