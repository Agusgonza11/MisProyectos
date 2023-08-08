WebTemplate::App.controllers :usuarios, :provides => [:json] do
  post :create, :map => '/usuarios' do
    begin
      logger.info("Headers: #{request.env}")
      logger.info("Query params: #{params}")
      autorizar(request.env)
      usuario = Usuario.new(usuario_params[:nombre_usuario].to_s, usuario_params[:nombre], usuario_params[:direccion], usuario_params[:telefono])
      status API_HTTP_CREADO
      usuario_to_json usuario_repo.save(usuario)
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
