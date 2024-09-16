class PresentadorUsuario
  MENSAJE_ERROR_DEFAULT = 'Hubo un problema, intente mas tarde.'.freeze
  TEXTO_ERROR_NO_AUTORIZADO = MENSAJE_ERROR_DEFAULT

  ERRORES = { 'solicitud_no_autorizada': TEXTO_ERROR_NO_AUTORIZADO }.freeze

  def presentar(usuario_registrado)
    "Bienvenido #{usuario_registrado.nombre}, tu id de usuario es #{usuario_registrado.nombre_usuario}."
  end

  def presentar_error(error)
    mensaje = ERRORES[error.id.to_sym]
    mensaje = MENSAJE_ERROR_DEFAULT if mensaje.nil?
    mensaje
  end
end
