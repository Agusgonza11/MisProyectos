describe Persistence::Repositories::RepartidorRepositorio do
  let(:repartidor_repo) { Persistence::Repositories::RepartidorRepositorio.new }
  let(:repartidor) { Repartidor.crear('repartidor1_repo', 'Nombre') }

  it 'deberia guardar un repartidor' do
    repartidor_repo.delete_all
    repartidor_repo.save(repartidor)
    expect(repartidor_repo.all.count).to eq(1)
  end

end
