describe Persistence::Repositories::PedidoRepositorio do
  let(:pedido_repo) { Persistence::Repositories::PedidoRepositorio.new }
  let(:usuario_repo) { Persistence::Repositories::UsuarioRepositorio.new }
  let(:repartidor_repo) { Persistence::Repositories::RepartidorRepositorio.new }


  it 'deberia guardar un pedido' do
    pedido_repo.delete_all
    usuario_repo.delete_all
    repartidor_repo.delete_all
    @usuario_hernan = Usuario.new('telegram_hernan', 'Hernan', 'PC850', '666555')
    pedido = Pedido.new('Menu parejas', EstadoPedidoRecibido.new, @usuario_hernan, 175, 2)
    usuario_repo.save(@usuario_hernan)
    pedido_repo.save(pedido)
    expect(pedido_repo.all.count).to eq(1)
  end

  context 'cuando existen pedidos' do
    before :each do
      pedido_repo.delete_all
      usuario_repo.delete_all
      repartidor_repo.delete_all
      @repartidor_hernan = Repartidor.crear('hernanCapo', 'hernan')
      @repartidor_nico = Repartidor.crear('nicoCapo', 'nico')
      @usuario_hernan = Usuario.new('telegram_hernan', 'Hernan', 'PC850', '666555')
      @usuario_nico = Usuario.new('telegram_nico', 'Nico', 'PC850', '666555')
      usuario_repo.save(@usuario_hernan)
      usuario_repo.save(@usuario_nico)
      @repartidor = repartidor_repo.save(@repartidor_hernan)
      @repartidor_nico = repartidor_repo.save(@repartidor_nico)
      @pedido_parejas = Pedido.new('Menu parejas', EstadoPedidoRecibido.new, @usuario_hernan, 175, 2, nil, @repartidor)
      @pedido_individual = Pedido.new('Menu individual', EstadoPedidoEntregado.new, @usuario_hernan, 100, 1, nil, @repartidor)
      @pedido_familiar = Pedido.new('Menu camiliar', EstadoPedidoRecibido.new, @usuario_nico, 250, 3, nil, @repartidor)
      @pedido_entregado = Pedido.new('Menu camiliar', EstadoPedidoEntregado.new, @usuario_nico, 250, 3, nil, @repartidor_nico)
      @pedido_individual.calificar(@usuario_hernan, 1,'horrible la comida, no pidan ahi por favor')
      @pedido_calificado = pedido_repo.save(@pedido_individual)
      pedido_repo.save(@pedido_parejas)
      pedido_repo.save(@pedido_familiar)
      pedido_repo.save(@pedido_entregado)
    end

    it 'deberia encontrar los pedidos de hernan' do
      expect(pedido_repo.buscar_por_usuario(@usuario_hernan).count).to eq(2)
    end

    it 'deberia encontrar los pedidos de nico' do
      expect(pedido_repo.buscar_por_usuario(@usuario_nico).count).to eq(2)
    end

    it 'deberia encontrar los pedidos entregados por hernan' do
      expect(pedido_repo.buscar_entregados_por_repartidor(@repartidor.id).count).to eq(1)
    end

    it 'deberia guardar la calificacion de un pedido' do
      expect(pedido_repo.find(@pedido_calificado.id).calificacion).to eq(1)
    end

    it 'deberia guardar el comentario de la calificacion de un pedido' do
      expect(pedido_repo.find(@pedido_calificado.id).comentario).to eq('horrible la comida, no pidan ahi por favor')
    end

    it 'deberia guardar el volumen de un pedido' do
      expect(pedido_repo.find(@pedido_calificado.id).volumen).to eq(1)
    end

    it 'deberia devolver pedidos pendientes de un usuario' do
      expect(pedido_repo.buscar_pedidos_pendientes_de(@usuario_nico).size).to eq 1
    end

  end

end
