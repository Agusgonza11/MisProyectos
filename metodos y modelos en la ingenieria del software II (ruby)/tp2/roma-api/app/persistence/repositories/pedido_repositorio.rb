module Persistence
  module Repositories
    class PedidoRepositorio < AbstractRepository
      self.table_name = :pedidos
      self.model_class = 'Pedido'

      def save(registro)
        if dataset.where(
          Sequel[id: registro.id]
        ).count.positive?
          return update(registro)
        end

        insert(registro)
        registro
      end

      def find(id)
        super(id)
      rescue ObjectNotFound
        raise PedidoNoEncontrado
      end

      def buscar_por_usuario(usuario)
        load_collection dataset.where(id_usuario: usuario.id)
      end

      def buscar_entregados_por_repartidor(repartidor)
        load_collection dataset.where(repartidor: repartidor, estado: 'entregado')
      end

      def buscar_pedidos_pendientes_de(usuario)
        load_collection dataset.where(id_usuario: usuario.id, calificacion: nil, estado: 'entregado')
      end

      protected

      def insert(registro)
        id = dataset.insert(changeset(registro))
        registro.id = id
        registro
      end

      def update(registro)
        find_dataset_by_id(registro.id).update(changeset(registro))
        RepartidorRepositorio.new.update(registro.repartidor) unless registro.repartidor.nil?
        registro
      end

      def load_object(registro)
        usuario = UsuarioRepositorio.new.find(registro[:id_usuario])
        repartidor = nil
        repartidor = RepartidorRepositorio.new.find(registro[:repartidor]) unless registro[:repartidor].nil?
        Pedido.new(
          registro[:nombre_menu],
          FabricaEstadosPedido.fabricar(registro[:estado]),
          usuario,
          registro[:precio],
          registro[:volumen],
          registro[:id],
          repartidor,
          registro[:calificacion],
          registro[:comentario],
          registro[:fecha],
          registro[:clima]
        )
      end

      def changeset(pedido)
        {
          nombre_menu: pedido.nombre_menu,
          id_usuario: pedido.usuario.id,
          estado: pedido.estado.id,
          repartidor: pedido.repartidor&.id,
          precio: pedido.precio,
          calificacion: pedido.calificacion,
          comentario: pedido.comentario,
          volumen: pedido.volumen,
          fecha: pedido.fecha,
          clima: pedido.clima
        }
      end
    end
  end
end
