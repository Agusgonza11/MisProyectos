module WebTemplate
  class App
    module PedidoHelper
      def pedido_params
        @body ||= request.body.read
        JSON.parse(@body).symbolize_keys
      end

      def pedido_repo
        Persistence::Repositories::PedidoRepositorio.new
      end

      def pedido_to_json(pedido)
        pedido_atributos(pedido).to_json
      end

      def calificacion_to_json(pedido)
        {'id': pedido.id, 'calificacion': pedido.calificacion, 'comentario': pedido.comentario}.to_json
      end

      def pedidos_pendientes_to_json(mensaje_error, pedidos)
        pedidos_pendientes = []
        pedidos.each do |pedido|
          pedidos_pendientes << pedido_atributos(pedido)
        end
        {'error': mensaje_error, 'pedidos': pedidos_pendientes}.to_json
      end

      private

      def pedido_atributos(pedido)
        { id: pedido.id, nombre: pedido.nombre_menu, estado: pedido.estado.id, usuario: pedido.usuario.id, repartidor: pedido.repartidor&.id}
      end
    end

    helpers PedidoHelper
  end
end
