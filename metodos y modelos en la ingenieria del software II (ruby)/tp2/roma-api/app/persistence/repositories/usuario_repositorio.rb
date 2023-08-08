module Persistence
  module Repositories
    class UsuarioRepositorio < AbstractRepository
      self.table_name = :usuarios
      self.model_class = 'Usuario'

      def save(registro)
        puts registro
        if dataset.where(
          Sequel[nombre_usuario: registro.nombre_usuario]
        ).count.positive?
          return registro
        end

        insert(registro)
      end

      def buscar_usuario(otro)
        usuario = (load_collection dataset.where(Sequel[nombre_usuario: otro])).first
        raise UsuarioNoRegistrado if usuario.nil?

        usuario
      end

      def insert(registro)
        id = dataset.insert(changeset(registro))
        registro.id = id
        registro
      end

      protected

      def load_object(registro)
        Usuario.new(registro[:nombre_usuario], registro[:nombre], registro[:direccion], registro[:telefono], registro[:id])
      end

      def changeset(usuario)
        {
          nombre_usuario: usuario.nombre_usuario,
          nombre: usuario.nombre,
          direccion: usuario.direccion,
          telefono: usuario.telefono
        }
      end
    end
  end
end
