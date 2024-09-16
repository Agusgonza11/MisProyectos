class PresentadorPedido
  MENSAJE_ERROR_DEFAULT = 'Hubo un problema, intente mas tarde.'.freeze
  TEXTO_ESTADO_RECIBIDO = 'Recibido'.freeze
  TEXTO_ESTADO_EN_CAMINO = 'En camino'.freeze
  TEXTO_ESTADO_EN_PREPARACION = 'En preparacion'.freeze
  TEXTO_ESTADO_ENTREGADO = 'Entregado'.freeze
  TEXTO_ESTADO_EN_ESPERA = 'En espera'.freeze
  TEXTO_ESTADO_CANCELADO = 'Cancelado'.freeze

  ESTADOS_PEDIDO = { 'recibido': TEXTO_ESTADO_RECIBIDO,
                     'en_preparacion': TEXTO_ESTADO_EN_PREPARACION,
                     'en_camino': TEXTO_ESTADO_EN_CAMINO,
                     'entregado': TEXTO_ESTADO_ENTREGADO,
                     'en_espera': TEXTO_ESTADO_EN_ESPERA,
                     'cancelado': TEXTO_ESTADO_CANCELADO }.freeze

  TEXTO_ERROR_RESTRINGIDO = 'No podes operar con el pedido de otro usuario.'.freeze
  TEXTO_ERROR_PEDIDO_NO_ENTREGADO_CALIFICADO = 'No se puede calificar un pedido no entregado!'.freeze
  TEXTO_ERROR_PEDIDO_CALIFICADO = 'Este pedido ya está calificado.'.freeze
  TEXTO_ERROR_NO_ENCONTRADO = 'No encontre tu pedido, revisa el numero de pedido o realiza un pedido'.freeze
  TEXTO_ERROR_USUARIO_RESTRINGIDO = 'Para pedir tenes que estar registrado. Registrate con /registrarse <nombre>, <direccion>, <telefono>'.freeze
  TEXTO_ERROR_PEDIDO_YA_ENTREGADO = 'Tu pedido no se puede cancelar ya que esta en estado Entregado.'.freeze
  TEXTO_ERROR_PEDIDO_YA_EN_CAMINO = 'Tu pedido no se puede cancelar ya que esta en estado En camino.'.freeze
  TEXTO_ERROR_MENU_INEXISTENTE = 'Menu invalido. Para conocer los menus disponibles ingresa /menus.'.freeze
  TEXTO_ERROR_NO_AUTORIZADO = MENSAJE_ERROR_DEFAULT

  ERRORES = { 'pedido_no_entregado': TEXTO_ERROR_PEDIDO_NO_ENTREGADO_CALIFICADO,
              'pedido_ya_calificado': TEXTO_ERROR_PEDIDO_CALIFICADO,
              'consulta_restringida': TEXTO_ERROR_RESTRINGIDO,
              'calificacion_restringida': TEXTO_ERROR_RESTRINGIDO,
              'pedido_ya_en_camino': TEXTO_ERROR_PEDIDO_YA_EN_CAMINO,
              'pedido_ya_entregado': TEXTO_ERROR_PEDIDO_YA_ENTREGADO,
              'pedido_no_encontrado': TEXTO_ERROR_NO_ENCONTRADO,
              'cancelacion_restringida': TEXTO_ERROR_RESTRINGIDO,
              'solicitud_no_autorizada': TEXTO_ERROR_NO_AUTORIZADO,
              'usuario_no_registrado': TEXTO_ERROR_USUARIO_RESTRINGIDO,
              'menu_inexistente': TEXTO_ERROR_MENU_INEXISTENTE }.freeze

  def presentar_creacion(pedido)
    "Tu pedido de #{pedido.nombre} fue recibido con exito. Tu numero de pedido es #{pedido.id}"
  end

  def presentar_cancelacion(pedido)
    "Tu pedido de #{pedido.nombre} con id #{pedido.id} fue cancelado con exito."
  end

  def presentar_estado(pedido)
    estado_pedido = ESTADOS_PEDIDO[pedido.estado.to_sym]
    "El pedido #{pedido.id} esta en estado #{estado_pedido}."
  end

  def presentar_error(error)
    mensaje = ERRORES[error.id.to_sym]
    mensaje = MENSAJE_ERROR_DEFAULT if mensaje.nil?
    mensaje
  end

  def presentar_calificacion(pedido)
    calificacion_recibida = pedido.calificacion
    id_pedido = pedido.id
    comentario_recibido = pedido.comentario
    "Tu pedido con id #{id_pedido} fue calificado con #{calificacion_recibida}#{" y el comentario \"#{comentario_recibido}\"" unless comentario_recibido.nil?}."
  end

  def presentar_calificaciones_pendientes(calificaciones_pendientes)
    mensaje = "Tiene pedidos pendientes de calificación. Califique con /calificar <calificacion>, <comentario-opcional>\nTus Pedididos:"
    calificaciones_pendientes.pedidos_pendientes.each do |pedido|
      mensaje += "\n#{pedido.id} - #{pedido.nombre} - #{pedido.estado}"
    end
    mensaje
  end
end
