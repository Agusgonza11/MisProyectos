class PresentadorMenu
  MENSAJE_ERROR_DEFAULT = 'Hubo un problema, intente mas tarde.'.freeze
  TEXTO_ERROR_NO_AUTORIZADO = MENSAJE_ERROR_DEFAULT

  ERRORES = { 'solicitud_no_autorizada': TEXTO_ERROR_NO_AUTORIZADO }.freeze

  def presentar_listado(listado_menus)
    texto = ''
    listado_menus.each do |menu|
      texto += menu.id.to_s + '-' + menu.nombre + ' ($' + menu.precio.to_s + ")\n"
    end
    texto.chop
  end

  def presentar_error(error)
    mensaje = ERRORES[error.id.to_sym]
    mensaje = MENSAJE_ERROR_DEFAULT if mensaje.nil?
    mensaje
  end
end
