describe Persistence::Repositories::UsuarioRepositorio do
  let(:usuario_repo) { Persistence::Repositories::UsuarioRepositorio.new }
  let(:usuario) { Usuario.new('u1', 'Hernan', 'Paseo Colon 850', '555', []) }

  it 'deberia guardar un usuario' do
    usuario_repo.delete_all
    usuario_repo.save(usuario)
    expect(usuario_repo.all.count).to eq(1)
  end

end
