Cuando('pido un menu invalido con id {int}') do |numero_menu|
  registrar_usuario('menu_invalido', 'marcos', 'Santa Fe 458', '78951453', ENV['LANONNA_API_KEY'])
  @respuesta = crear_pedido(numero_menu, 'menu_invalido')
end

Entonces('recibo un mensaje de error') do
  expect(@respuesta.status).to eq 404
end
