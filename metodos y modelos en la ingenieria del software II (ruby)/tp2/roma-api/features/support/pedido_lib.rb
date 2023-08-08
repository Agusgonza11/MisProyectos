HEADER_AUTORIZACION = {'Authorization' => ENV['LANONNA_API_KEY']}.freeze
HEADER_AUTORIZACION_JSON = {'Content-Type' => 'application/json', 'Authorization' => ENV['LANONNA_API_KEY']}.freeze

def avanzar_estado(id)
  Faraday.post("#{BASE_URL}/pedidos/#{id}/estado", nil, HEADER_AUTORIZACION)
end

def crear_pedido(numero_menu, nombre_usuario)
  pedido = {numero_menu: numero_menu, nombre_usuario: nombre_usuario}
  Faraday.post("#{BASE_URL}/pedidos", pedido.to_json, HEADER_AUTORIZACION_JSON)
end

def pedido_estado_preparacion(id_pedido)
  avanzar_estado(id_pedido)
end

def pedido_estado_en_espera(id_pedido)
  avanzar_estado(id_pedido)
  avanzar_estado(id_pedido)
end

def pedido_estado_en_camino(id_pedido)
  avanzar_estado(id_pedido)
  avanzar_estado(id_pedido)
end

def pedido_estado_entregado(id_pedido)
  avanzar_estado(id_pedido)
  avanzar_estado(id_pedido)
  avanzar_estado(id_pedido)
end

def calificar_pedido(id_pedido, nombre_usuario, calificacion, comentario = nil)
  calificacion_enviada = {id_pedido: id_pedido, nombre_usuario: nombre_usuario, calificacion: calificacion, comentario: comentario}
  Faraday.patch("#{BASE_URL}/pedidos/#{@id_pedido}", calificacion_enviada.to_json, HEADER_AUTORIZACION_JSON)
end

def cancelar_pedido(id, nombre_usuario)
  Faraday.post("#{BASE_URL}/pedidos/#{id}/estado/cancelado", {nombre_usuario: nombre_usuario}, HEADER_AUTORIZACION)
end

def consultar_menus
  Faraday.get("#{BASE_URL}/menus", nil, HEADER_AUTORIZACION)
end

def consultar_estado_pedido(id_pedido, nombre_usuario)
  Faraday.get("#{BASE_URL}/pedidos/#{id_pedido}", {nombre_usuario: nombre_usuario}, HEADER_AUTORIZACION)
end
