module WebTemplate
  class App < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers

    Padrino.configure :development, :test do
    end

    Padrino.configure :staging, :production do
    end

    get '/' do
      "Roma version: #{Version.current}"
    end

    post '/reset', :provides => [:js] do
      if ENV['ENABLE_RESET'] == 'true'
        repartidor_repo.delete_all
        usuario_repo.delete_all
        status 200
        {message: 'reset ok'}.to_json
      else
        status 403
        {message: 'reset not enabled'}.to_json
      end
    end

    post '/clima', :provides => [:js] do
      begin
        if ENV['ENABLE_MOCK_CLIMA'] == 'true'
          ApiClima.setear_clima(params['clima'])
          status 200
          {message: "Simulacion clima #{params['clima']} habilitado."}.to_json
        else
          status 403
          {message: 'Simulacion clima no disponible.'}.to_json
        end
      rescue ClimaNoReconocido => e
        status 400
        {message: e.message}.to_json
      end
    end

    get :docs, map: '/docs' do
      render 'docs'
    end
  end
end
