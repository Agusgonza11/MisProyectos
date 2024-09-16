WebTemplate::App.controllers :repartidores, :provides => [:json] do
  post :create, :map => '/repartidores' do
    begin
      logger.info("Headers: #{request.env}")
      logger.info("Query params: #{params}")
      autorizar(request.env)
      repartidor = Repartidor.crear(repartidor_params[:nombre_usuario], repartidor_params[:nombre])
      status API_HTTP_CREADO
      repartidor_to_json repartidor_repo.save(repartidor)
    rescue AutorizacionInvalida => e
      logger.error(e.message)
      status API_HTTP_NO_AUTORIZADO
      { error: e.message }.to_json
    rescue Exception => e
      logger.error(e.message)
      status API_HTTP_ERROR_INTERNO
      {error: e.message}.to_json
    end
  end

  get :create, :map => '/repartidores/:id/comision' do
    begin
      logger.info("Headers: #{request.env}")
      logger.info("Query params: #{params}")
      autorizar(request.env)
      pedidos = pedido_repo.buscar_entregados_por_repartidor(params[:id])
      comision = LaNonna.calcular_comision(pedidos, Contador.new)
      status API_HTTP_OK
      comision_to_json(comision, params[:id])
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

  post :create, :map => '/repartidores/:id/estado' do
    begin
      logger.info("Headers: #{request.env}")
      logger.info("Query params: #{params}")
      autorizar(request.env)
      repartidor = repartidor_repo.find(params[:id])
      repartidor.avanzar_estado
      status API_HTTP_OK
      repartidor_to_json(repartidor_repo.save(repartidor))
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
end
