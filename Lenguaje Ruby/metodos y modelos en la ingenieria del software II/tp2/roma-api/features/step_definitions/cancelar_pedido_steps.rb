Dado('que mi pedido esta en estado Recibido') do
end

Cuando('cancelo mi pedido') do
  @respuesta_cancelado = cancelar_pedido(@id_pedido, @usuario[:nombre_usuario])
end

Entonces('recibo el mensaje de cancelacion del pedido') do
  expect(JSON.parse(@respuesta_cancelado.body)['estado']).to eq 'cancelado'
end

Dado('que mi pedido esta en estado En preparacion') do
  pedido_estado_preparacion(@id_pedido)
end

Dado('que mi pedido esta en estado En espera') do
  pedido_estado_en_espera(@id_pedido)
end
