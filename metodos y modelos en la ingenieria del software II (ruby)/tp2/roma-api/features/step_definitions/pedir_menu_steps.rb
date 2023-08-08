TIPO_DE_MENUS = {"Menu individual": '1', "Menu parejas": '2', "Menu familiar": '3'}.freeze

Dado('que estoy registrado') do
  @usuario = {nombre_usuario: 'pedirMenu01', nombre: 'tomas', direccion: 'Santa Fe 1024', telefono: '46857314'}
  registrar_usuario('pedirMenu01', 'tomas', 'Cordoba 123', '75423453', ENV['LANONNA_API_KEY'])
end

Cuando('realizo el pedido de menú {string}') do |tipo_de_menu|
  @respuesta = crear_pedido(TIPO_DE_MENUS[tipo_de_menu.to_sym], @usuario[:nombre_usuario])
end

Entonces('veo el mensaje de pedido {string} recibido') do |tipo_de_menu|
  expect(JSON.parse(@respuesta.body)['nombre']).to eq tipo_de_menu
end
