module Persistence
  module Repositories
    class RepartidorRepositorio < AbstractRepository
      self.table_name = :repartidores
      self.model_class = 'Repartidor'

      def save(registro)
        if dataset.where(
          Sequel[nombre_usuario: registro.nombre_usuario]
        ).count.positive?
          return update(registro)
        end

        insert(registro)
      end

      def insert(registro)
        id = dataset.insert(changeset(registro))
        registro.id = id
        registro
      end

      # def buscar_repartidor_por_nombre_usuario(nombre_usuario)
      #  registro_encontrado = dataset.where(Sequel[nombre_usuario: nombre_usuario])
      #  raise ObjectNotFound.new(self.class.model_class, id) if registro_encontrado.nil?

      #  load_collection(registro_encontrado).first
      # end

      def update(registro)
        find_dataset_by_id(registro.id).update(changeset(registro))
        registro
      end

      protected

      def load_object(registro)
        Repartidor.new(registro[:nombre_usuario], registro[:nombre], registro[:id], registro[:espacio_ocupado], FabricaEstadosRepartidor.fabricar(registro[:estado]))
      end

      def changeset(repartidor)
        {
          nombre_usuario: repartidor.nombre_usuario,
          nombre: repartidor.nombre,
          estado: repartidor.estado.id,
          espacio_ocupado: repartidor.espacio_ocupado
        }
      end
    end
  end
end
