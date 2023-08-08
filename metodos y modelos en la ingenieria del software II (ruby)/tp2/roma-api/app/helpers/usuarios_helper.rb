module WebTemplate
  class App
    module UsuarioHelper
      def usuario_params
        @body ||= request.body.read
        JSON.parse(@body).symbolize_keys
      end

      def usuario_repo
        Persistence::Repositories::UsuarioRepositorio.new
      end

      def usuario_to_json(usuario)
        usuario_atributos(usuario).to_json
      end

      private

      def usuario_atributos(usuario)
        {nombre_usuario: usuario.nombre_usuario, nombre: usuario.nombre, direccion: usuario.direccion, telefono: usuario.telefono}
      end
    end

    helpers UsuarioHelper
  end
end
