def crear_repartidor(nombre_usuario, nombre = 'hernan')
  repartidor = {nombre_usuario: nombre_usuario, nombre: nombre}
  Faraday.post("#{BASE_URL}/repartidores", repartidor.to_json, HEADER_AUTORIZACION_JSON)
end

def calcular_comision(repartidor_id)
  Faraday.get("#{BASE_URL}/repartidores/#{repartidor_id}/comision", nil, HEADER_AUTORIZACION)
end

def cambiar_estado_repartidor(repartidor_id)
  Faraday.post("#{BASE_URL}/repartidores/#{repartidor_id}/estado", nil, HEADER_AUTORIZACION)
end
