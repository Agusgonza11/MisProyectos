Cuando('el usuario cancela el pedido') do
  @respuesta = cancelar_pedido(@id_pedido, @usuario[:nombre_usuario])
end

Entonces('recibe el mensaje de que no se puede cancelar el pedido') do
  expect(@respuesta.status).to eq 409
end

Dado('que el pedido esta en estado Entregado') do
  crear_repartidor('carlos_repartidor')
  pedido_estado_entregado(@id_pedido)
end
