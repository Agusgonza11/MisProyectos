module WebTemplate
  class App
    module RepartidorHelper
      def repartidor_params
        @body ||= request.body.read
        JSON.parse(@body).symbolize_keys
      end

      def repartidor_repo
        Persistence::Repositories::RepartidorRepositorio.new
      end

      def repartidor_to_json(repartidor)
        repartidor_atributos(repartidor).to_json
      end

      private

      def repartidor_atributos(repartidor)
        { id: repartidor.id, nombre_usuario: repartidor.nombre_usuario, nombre: repartidor.nombre,
          estado: repartidor.estado.id, espacio_ocupado: repartidor.espacio_ocupado }
      end
    end

    helpers RepartidorHelper
  end
end
