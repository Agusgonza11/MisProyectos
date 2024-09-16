Dado('que existe un pedido de {string} con estado {string}') do |nombre_menu, _estado|
  registrar_usuario('listo_para_entregar_1', 'hernancito', 'Cordoba 123', '75423453', ENV['LANONNA_API_KEY'])

  @respuesta = crear_pedido(TIPO_DE_MENUS[nombre_menu.to_sym], 'listo_para_entregar_1')
  @id_pedido = JSON.parse(@respuesta.body)['id']
  avanzar_estado(@id_pedido)
end

Dado('existe un repartidor con la mochila vacia') do
  @repartidor = crear_repartidor('hernan_repartidor')
end

Cuando('quiero despachar el pedido') do
  @respuesta = avanzar_estado(@id_pedido)
end

Dado('existe un repartidor con un pedido de {string}') do |nombre_menu|
  @repartidor = crear_repartidor('hernan_repartidor')

  @respuesta = crear_pedido(TIPO_DE_MENUS[nombre_menu.to_sym], 'listo_para_entregar_1')
  id = JSON.parse(@respuesta.body)['id']

  pedido_estado_en_camino(id)
end

Dado('que existe un pedido de {string} en preparacion') do |nombre_menu|
  registrar_usuario('listo_para_entregar_2', 'hernancito', 'Cordoba 123', '75423453', ENV['LANONNA_API_KEY'])

  @respuesta = crear_pedido(TIPO_DE_MENUS[nombre_menu.to_sym], 'listo_para_entregar_2')
  @id_pedido = JSON.parse(@respuesta.body)['id']

  avanzar_estado(@id_pedido)
end

Dado('no hay repartidores') do
end

Cuando('despacho el pedido') do
  @respuesta = avanzar_estado(@id_pedido)
end

Dado('que existe un pedido de {string} en espera') do |nombre_menu|
  @usuario = {nombre_usuario: 'listo_para_entregar_3', nombre: 'hernancito', direccion: 'Cordoba 123', telefono: '75423453'}
  registrar_usuario('listo_para_entregar_3', 'hernancito', 'Cordoba 123', '75423453', ENV['LANONNA_API_KEY'])

  @respuesta = crear_pedido(TIPO_DE_MENUS[nombre_menu.to_sym], 'listo_para_entregar_3')
  @id_pedido = JSON.parse(@respuesta.body)['id']

  pedido_estado_en_espera(@id_pedido)
end

Cuando('creo un repartidor') do
  @repartidor = crear_repartidor('hernan_repartidor')
end
