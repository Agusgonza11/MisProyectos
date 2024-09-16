WebTemplate::App.controllers :pedidos, :provides => [:json] do
  get :show, :map => '/menus' do
    begin
      logger.info("Headers: #{request.env}")
      logger.info("Query params: #{params}")
      autorizar(request.env)
      status API_HTTP_OK
      FabricaPedidos.menus_disponibles.to_json
    rescue AutorizacionInvalida => e
      logger.error(e.message)
      status API_HTTP_NO_AUTORIZADO
      { error: e.message }.to_json
    end
  end

  get :show, :map => '/pedidos', :with => :id do
    begin
      logger.info("Headers: #{request.env}")
      logger.info("Query params: #{params}")
      autorizar(request.env)
      pedido = pedido_repo.find(params[:id])
      usuario = usuario_repo.buscar_usuario(params[:nombre_usuario])
      pedido_to_json(pedido.consultar(usuario))
    rescue AutorizacionInvalida => e
      logger.error(e.message)
      status API_HTTP_NO_AUTORIZADO
      { error: e.message }.to_json
    rescue ConsultaRestringida => e
      logger.error(e.message)
      status API_HTTP_RECURSO_RESTRINGIDO
      { error: e.message }.to_json
    rescue PedidoNoEncontrado => e
      logger.error(e.message)
      status API_HTTP_NO_ENCONTRADO
      { error: e.message }.to_json
    rescue Exception => e
      logger.error(e.message)
      status API_HTTP_ERROR_INTERNO
      { error: e.message }.to_json
    end
  end

  post :create, :map => '/pedidos' do
    begin
      logger.info("Headers: #{request.env}")
      logger.info("Query params: #{params}")
      autorizar(request.env)
      usuario = usuario_repo.buscar_usuario(pedido_params[:nombre_usuario])
      pedidos_pendientes = pedido_repo.buscar_pedidos_pendientes_de(usuario)
      LaNonna.validar_calificaciones_pendientes(pedidos_pendientes)
      fecha = Fecha.new
      pedido = FabricaPedidos.fabricar(pedido_params[:numero_menu], usuario, fecha, ApiClima.instance)
      status API_HTTP_CREADO
      pedido_to_json(pedido_repo.save(pedido))
    rescue CalificacionesPendientes => e
      logger.error(e.message)
      status API_HTTP_ERROR_ESTADO
      pedidos_pendientes_to_json(e.message, pedidos_pendientes)
    rescue MenuInexistente => e
      logger.error(e.message)
      status API_HTTP_NO_ENCONTRADO
      { error: e.message }.to_json
    rescue AutorizacionInvalida => e
      logger.error(e.message)
      status API_HTTP_NO_AUTORIZADO
      { error: e.message }.to_json
    rescue UsuarioNoRegistrado => e
      logger.error(e.message)
      status API_HTTP_RECURSO_RESTRINGIDO
      { error: e.message }.to_json
    rescue SolicitudClimaError => e
      logger.error(e.message)
      status API_HTTP_ERROR_INTERNO
      { error: e.message }.to_json
    rescue Exception => e
      logger.error(e.message)
      status API_HTTP_ERROR_INTERNO
      { error: e.message }.to_json
    end
  end

  post :create, :map => '/pedidos/:id/estado' do
    begin
      logger.info("Headers: #{request.env}")
      logger.info("Query params: #{params}")
      autorizar(request.env)
      pedido = pedido_repo.find(params[:id])
      repartidores = repartidor_repo.all
      la_nonna = LaNonna.new(repartidores)
      pedido.avanzar_estado(la_nonna)
      status API_HTTP_OK
      pedido_to_json(pedido_repo.save(pedido))
    rescue AutorizacionInvalida => e
      logger.error(e.message)
      status API_HTTP_NO_AUTORIZADO
      { error: e.message }.to_json
    rescue Exception => e
      logger.error(e.message)
      status API_HTTP_ERROR_INTERNO
      { error: e.message }.to_json
    end
  end

  patch :create, :map => '/pedidos/:id' do
    begin
      logger.info("Headers: #{request.env}")
      logger.info("Query params: #{params}")
      autorizar(request.env)
      pedido = pedido_repo.find(params[:id])
      usuario = usuario_repo.buscar_usuario(pedido_params[:nombre_usuario])
      pedido.calificar(usuario, pedido_params[:calificacion].to_i, pedido_params[:comentario])
      status API_HTTP_OK
      calificacion_to_json(pedido_repo.save(pedido))
    rescue AutorizacionInvalida => e
      logger.error(e.message)
      status API_HTTP_NO_AUTORIZADO
      { error: e.message }.to_json
    rescue ValorDeCalificacionInvalido => e
      logger.error(e.message)
      status API_HTTP_ERROR_ESTADO
      { error: e.message }.to_json
    rescue CalificacionRestringida => e
      logger.error(e.message)
      status API_HTTP_RECURSO_RESTRINGIDO
      { error: e.message }.to_json
    rescue PedidoNoEntregado => e
      logger.error(e.message)
      status API_HTTP_ERROR_ESTADO
      { error: e.message }.to_json
    rescue PedidoYaCalificado => e
      logger.error(e.message)
      status API_HTTP_ERROR_ESTADO
      { error: e.message }.to_json
    rescue PedidoNoEncontrado => e
      logger.error(e.message)
      status API_HTTP_NO_ENCONTRADO
      { error: e.message }.to_json
    rescue UsuarioNoRegistrado => e
      logger.error(e.message)
      status API_HTTP_RECURSO_RESTRINGIDO
      { error: e.message }.to_json
    rescue Exception => e
      logger.error(e.message)
      status API_HTTP_ERROR_INTERNO
      { error: e.message }.to_json
    end
  end

  post :create, :map => '/pedidos/:id/estado/cancelado' do
    begin
      logger.info("Headers: #{request.env}")
      logger.info("Query params: #{params}")
      autorizar(request.env)
      pedido = pedido_repo.find(params[:id])
      usuario = usuario_repo.buscar_usuario(params[:nombre_usuario])
      pedido.cancelar(usuario)
      status API_HTTP_OK
      pedido_to_json(pedido_repo.save(pedido))
    rescue AutorizacionInvalida => e
      logger.error(e.message)
      status API_HTTP_NO_AUTORIZADO
      { error: e.message }.to_json
    rescue CancelacionRestringida => e
      logger.error(e.message)
      status API_HTTP_RECURSO_RESTRINGIDO
      { error: e.message }.to_json
    rescue PedidoNoEncontrado => e
      logger.error(e.message)
      status API_HTTP_NO_ENCONTRADO
      { error: e.message }.to_json
    rescue UsuarioNoRegistrado => e
      logger.error(e.message)
      status API_HTTP_RECURSO_RESTRINGIDO
      { error: e.message }.to_json
    rescue PedidoYaEnCamino => e
      logger.error(e.message)
      status API_HTTP_ERROR_ESTADO
      { error: e.message }.to_json
    rescue PedidoYaEntregado => e
      logger.error(e.message)
      status API_HTTP_ERROR_ESTADO
      { error: e.message }.to_json
    rescue Exception => e
      logger.error(e.message)
      status API_HTTP_ERROR_INTERNO
      { error: e.message }.to_json
    end
  end
end
