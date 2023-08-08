def registrar_usuario(nombre_usuario, nombre, direccion, telefono, api_key)
  usuario = {nombre_usuario: nombre_usuario, nombre: nombre, direccion: direccion, telefono: telefono}
  Faraday.post("#{BASE_URL}/usuarios", usuario.to_json, {'Content-Type' => 'application/json', 'Authorization' => api_key})
end
