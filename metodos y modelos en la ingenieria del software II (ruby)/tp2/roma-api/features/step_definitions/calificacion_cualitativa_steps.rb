Cuando('califico mi pedido con calificacion {int} y con el comentario {string}') do |calificacion, comentario|
  @respuesta = calificar_pedido(@id_pedido, 'calificacion_menu1', calificacion, comentario)
end

Entonces('recibo con el comentario {string}') do |comentario|
  expect(JSON.parse(@respuesta.body)['comentario']).to eq comentario
end
