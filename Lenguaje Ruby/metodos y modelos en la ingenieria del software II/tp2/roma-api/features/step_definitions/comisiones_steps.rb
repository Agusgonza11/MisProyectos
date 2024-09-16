TIPO_DE_MENUS = {"Menu individual": '1', "Menu parejas": '2', "Menu familiar": '3'}.freeze

Dado('que existe un repartidor {string}') do |_nombre_repartidor|
  @repartidor = crear_repartidor('repartidor_comision01')
end

Dado('que existe un pedido de {string} con precio {float} entregado por el repartidor {string}') do |nombre_menu, _comision, _nombre_repartidor|
  @usuario = registrar_usuario('usuario_comision01', 'hernancito', 'Cordoba 123', '75423453', ENV['LANONNA_API_KEY'])
  @pedido = crear_pedido(TIPO_DE_MENUS[nombre_menu.to_sym], 'usuario_comision01')
  @id_pedido = JSON.parse(@pedido.body)['id']
  pedido_estado_entregado(@id_pedido)
end

Dado('que existe otro pedido de {string} con precio {float} entregado por el repartidor {string}') do |nombre_menu, _comision, _nombre_repartidor|
  @usuario = registrar_usuario('otro_usuario0123', 'hernancito', 'Cordoba 123', '75423453', ENV['LANONNA_API_KEY'])
  @pedido = crear_pedido(TIPO_DE_MENUS[nombre_menu.to_sym], 'otro_usuario0123')
  @id_pedido = JSON.parse(@pedido.body)['id']
  pedido_estado_entregado(@id_pedido)
end

Cuando('calculo la comision') do
  @repartidor_id = JSON.parse(@repartidor.body)['id']
  @comision = calcular_comision(@repartidor_id)
end

Entonces('para el repartidor {string} obtengo {float} como comision') do |_repartidor, comision|
  expect(JSON.parse(@comision.body)['comision']).to be_within(0.01).of(comision)
  expect(JSON.parse(@comision.body)['id']).to eq @repartidor_id.to_s
end

Dado('se calificó con {int}') do |calificacion|
  @respuesta = calificar_pedido(@id_pedido, 'usuario_comision01', calificacion)
end

Dado('que existe un pedido de {string} con precio {int} entregado por el repartidor {string} un dia de lluvia') do |nombre_menu, _comision, _nombre_repartidor|
  Faraday.post("#{BASE_URL}/clima", clima: 'lluvioso')
  @usuario = registrar_usuario('usuario_comision01', 'hernancito', 'Cordoba 123', '75423453', ENV['LANONNA_API_KEY'])

  @pedido = crear_pedido(TIPO_DE_MENUS[nombre_menu.to_sym], 'usuario_comision01')
  @id_pedido = JSON.parse(@pedido.body)['id']
  pedido_estado_entregado(@id_pedido)
end
