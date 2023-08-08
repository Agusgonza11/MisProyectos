require 'spec_helper'

describe Repartidor do
  subject(:repartidor) { described_class.new('hernancapo123', 'hernan')}

  describe 'modelo' do
    it { is_expected.to respond_to(:nombre_usuario) }
    it { is_expected.to respond_to(:nombre) }
    it { is_expected.to respond_to(:estado) }
    it { is_expected.to respond_to(:espacio_ocupado) }
  end

  describe 'asignar pedido' do
    let(:pedido_individual) { Pedido.new('Menu individual', EstadoPedidoEnCamino.new, nil, 100, 1) }
    let(:pedido_familiar)   { Pedido.new('Menu familiar', EstadoPedidoEnCamino.new, nil, 250, 3) }

    it 'deberia asignar el pedido al repartidor' do
      repartidor_mochila = Repartidor.new('hernancapo123', 'hernan')
      repartidor_mochila.asignar_pedido(pedido_individual)
      expect(repartidor_mochila.espacio_ocupado).to eq 1
    end

    it 'deberia obtener NoHayEspacio en la mochila si esta completa' do
      repartidor_mochila = Repartidor.new('hernancapo123', 'hernan')
      repartidor_mochila.asignar_pedido(pedido_familiar)
      expect{repartidor_mochila.asignar_pedido(pedido_individual)}.to raise_error NoHayEspacio
    end
  end

  describe 'espacio ocupado' do
    let(:pedido_individual) { Pedido.new('Menu individual', EstadoPedidoEnCamino.new, nil, 100, 1) }
    let(:pedido_parejas)    { Pedido.new('Menu parejas', EstadoPedidoEnCamino.new, nil, 175, 2) }
    let(:pedido_familiar)   { Pedido.new('Menu familiar', EstadoPedidoEnCamino.new, nil, 250, 3) }

    it 'el espacio ocupado deberia ser 0 cuando no tiene pedidos' do
      repartidor_mochila = Repartidor.new('hernancapo123', 'hernan')
      expect(repartidor_mochila.espacio_ocupado).to eq 0
    end

    it 'el espacio ocupado deberia ser 1 al asignarle un pedido individual' do
      repartidor_mochila = Repartidor.new('hernancapo123', 'hernan')
      repartidor_mochila.asignar_pedido(pedido_individual)
      expect(repartidor_mochila.espacio_ocupado).to eq 1
    end

    it 'el espacio ocupado deberia ser 2 al asignarle dos pedidos individuales' do
      repartidor_mochila = Repartidor.new('hernancapo123', 'hernan')
      repartidor_mochila.asignar_pedido(pedido_individual)
      repartidor_mochila.asignar_pedido(pedido_individual)
      expect(repartidor_mochila.espacio_ocupado).to eq 2
    end

    it 'el espacio ocupado deberia ser 3 al asignarle un pedido individual y un pedido parejas' do
      repartidor_mochila = Repartidor.new('hernancapo123', 'hernan')
      repartidor_mochila.asignar_pedido(pedido_individual)
      repartidor_mochila.asignar_pedido(pedido_parejas)
      expect(repartidor_mochila.espacio_ocupado).to eq 3
    end

    it 'el espacio ocupado deberia ser 3 al asignarle un pedido familiar' do
      repartidor_mochila = Repartidor.new('hernancapo123', 'hernan')
      repartidor_mochila.asignar_pedido(pedido_familiar)
      expect(repartidor_mochila.espacio_ocupado).to eq 3
    end

    it 'el espacio ocupado deberia ser 0 al asignarle un pedido familiar y luego entregarlo' do
      repartidor_mochila = Repartidor.new('hernancapo123', 'hernan')
      repartidor_mochila.asignar_pedido(pedido_familiar)
      repartidor_mochila.entregar_pedido_con_volumen(pedido_familiar.volumen)
      expect(repartidor_mochila.espacio_ocupado).to eq 0
    end

  end

  describe 'estados' do
    let(:pedido_individual) { Pedido.new('Menu individual', EstadoPedidoEnCamino.new, nil, 100, 1) }

    it 'el estado del repartidor inicialmente es disponible' do
      repartidor_estado = Repartidor.crear('hernancapo123', 'hernan')
      expect(repartidor_estado.estado.id).to eq 'disponible'
    end

    it 'el estado del repartidor al ser despachado es en camino' do
      repartidor_estado = Repartidor.crear('hernancapo123', 'hernan')
      repartidor_estado.asignar_pedido(pedido_individual)
      repartidor_estado.avanzar_estado
      expect(repartidor_estado.estado.id).to eq 'en_camino'
    end

    it 'el estado del repartidor al volver deberia ser disponible' do
      repartidor_estado = Repartidor.crear('hernancapo123', 'hernan')
      repartidor_estado.asignar_pedido(pedido_individual)
      repartidor_estado.avanzar_estado
      repartidor_estado.avanzar_estado
      expect(repartidor_estado.estado.id).to eq 'disponible'
    end
  end

end
