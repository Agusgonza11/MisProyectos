class UsuarioNoRegistrado < StandardError
  def initialize
    super('usuario_no_registrado')
  end
end
