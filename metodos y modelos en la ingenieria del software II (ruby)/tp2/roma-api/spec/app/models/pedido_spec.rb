require 'spec_helper'

describe Pedido do
  let(:usuario_pedido) { Usuario.new('u1','nombre_u1','una direccion','12345')}
  subject(:pedido) { described_class.new('Menu individual', EstadoPedidoRecibido.new, usuario_pedido, 100, 1) }  

  describe 'modelo' do
    it { is_expected.to respond_to(:nombre_menu) }
    it { is_expected.to respond_to(:estado) }
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:usuario) }
    it { is_expected.to respond_to(:repartidor) }
    it { is_expected.to respond_to(:precio) }
    it { is_expected.to respond_to(:calificacion) }
    it { is_expected.to respond_to(:comentario) }
    it { is_expected.to respond_to(:volumen) }
    it { is_expected.to respond_to(:fecha) }
    it { is_expected.to respond_to(:clima) }
  end

  describe 'avanzar estados' do
    let(:repartidor) { Repartidor.new('hernancapo123', 'hernan', 1) }
    let(:la_nonna) { LaNonna.new([repartidor]) }
    let(:fecha_no_lluvia) { instance_double('Fecha', hoy: Date.new(2022,11,19)) }
    let(:api_clima) { instance_double('ApiClima', clima: 'soleado') }

    it 'un pedido recibido deberia cambiar a en_preparacion' do
      pedido = described_class.crear('Menu familiar', EstadoPedidoRecibido.new, usuario_pedido, 250, 3, fecha_no_lluvia, api_clima)
      pedido.avanzar_estado(la_nonna)
      expect(pedido.estado.id).to eq 'en_preparacion'
    end

    it 'un pedido en_preparacion deberia cambiar a en_camino' do
      pedido = described_class.crear('Menu familiar', EstadoPedidoEnPreparacion.new, usuario_pedido, 250, 3, fecha_no_lluvia, api_clima)
      pedido.avanzar_estado(la_nonna)
      expect(pedido.estado.id).to eq 'en_camino'
    end

    it 'un pedido en_camino deberia cambiar a entregado' do
      pedido = described_class.new('Menu familiar', EstadoPedidoEnCamino.new, usuario_pedido, 250,3 , nil, repartidor, api_clima)
      pedido.avanzar_estado(la_nonna)
      expect(pedido.estado.id).to eq 'entregado'
    end

    it 'deberia calcular comision con su precio' do
      pedido = described_class.crear('Menu individual', EstadoPedidoEnCamino.new, usuario_pedido, 100, 1, fecha_no_lluvia, api_clima)
      expect(pedido.obtener_comision(Contador.new)).to be_within(0.01).of(5)
    end

    it 'poner un pedido en_espera deberia cambiar a en_espera' do
      pedido = described_class.crear('Menu familiar', EstadoPedidoEnPreparacion.new, usuario_pedido, 250, 3, fecha_no_lluvia, api_clima)
      pedido.avanzar_estado(la_nonna)
      expect(pedido.estado.id).to eq 'en_camino'
    end

    it 'un pedido en_espera deberia cambiar a en_camino' do
      pedido = described_class.crear('Menu familiar', EstadoPedidoEnEspera.new, usuario_pedido, 250, 3, fecha_no_lluvia, api_clima)
      pedido.avanzar_estado(la_nonna)
      expect(pedido.estado.id).to eq 'en_camino'
    end

    it 'deberia lanzar PedidoNoEntregado si el pedido no esta en estado entregado' do
      pedido = described_class.crear('Menu familiar', EstadoPedidoEnPreparacion.new, usuario_pedido, 250, 3, fecha_no_lluvia, api_clima)
      expect{pedido.calificar(usuario_pedido, 1, 'una opinion')}.to raise_error PedidoNoEntregado
    end

    it 'deberia calcular comision con su precio y calificacion' do
      pedido = described_class.new('Menu familiar', EstadoPedidoEntregado.new, usuario_pedido, 250, 3, nil, nil, 5, nil, fecha_no_lluvia.hoy)
      expect(pedido.obtener_comision(Contador.new)).to be_within(0.01).of(17.5)
    end

    it 'deberia lanzar PedidoYaCalificado si el pedido ya fue calificado anteriormente' do
      pedido = described_class.new('Menu parejas', EstadoPedidoEntregado.new, usuario_pedido, 175, 2, nil, nil, 5)
      expect{pedido.calificar(usuario_pedido, 4, 'otra opinion')}.to raise_error PedidoYaCalificado
    end

    it 'deberia devolver el pedido si el usuario que consulta es el dueño' do
      usuario_consultante = Usuario.new('un_usuario', 'nombre', 'direccion', '12345678', 431515)
      pedido = described_class.new('Menu parejas', EstadoPedidoEntregado.new, usuario_consultante, 175, 2, 5421678)
      expect(pedido.consultar(usuario_consultante).id).to eq 5421678
    end

    it 'deberia devolver un mensaje de error cuando se intenta consultar un pedido ajeno' do
      usuario_dueno = Usuario.new('un_usuario', 'nombre', 'direccion', '12345678', 1)
      usuario_consultante = Usuario.new('un_usuario', 'nombre', 'direccion', '12345678', 431515)
      pedido = described_class.new('Menu parejas', EstadoPedidoEntregado.new, usuario_dueno, 175, 2, 5)
      expect{pedido.consultar(usuario_consultante)}.to raise_error ConsultaRestringida
    end

    it 'deberia devolver un mensaje de error cuando se intenta calificar un pedido ajeno' do
      usuario_dueno = Usuario.new('un_usuario', 'nombre', 'direccion', '12345678', 1)
      usuario_calificador = Usuario.new('un_usuario', 'nombre', 'direccion', '12345678', 431515)
      pedido = described_class.new('Menu parejas', EstadoPedidoEntregado.new, usuario_dueno, 175, 2, 5)
      expect{pedido.calificar(usuario_calificador,3)}.to raise_error CalificacionRestringida
    end

    it 'deberia devolver un mensaje de error cuando se intenta cancelar un pedido ajeno' do
      usuario_dueno = Usuario.new('un_usuario', 'nombre', 'direccion', '12345678', 1)
      usuario_cancelador = Usuario.new('un_usuario', 'nombre', 'direccion', '12345678', 431515)
      pedido = described_class.new('Menu parejas', EstadoPedidoEnPreparacion.new, usuario_dueno, 175, 2, 5)
      expect{pedido.cancelar(usuario_cancelador)}.to raise_error CancelacionRestringida
    end

    it 'un pedido recibido deberia poder ser cancelado' do
      pedido = described_class.crear('Menu familiar', EstadoPedidoRecibido.new, usuario_pedido, 250, 3, fecha_no_lluvia, api_clima)
      pedido.cancelar(usuario_pedido)
      expect(pedido.estado.id).to eq 'cancelado'
    end

    it 'un pedido en preparacion deberia poder ser cancelado' do
      pedido = described_class.crear('Menu familiar', EstadoPedidoEnPreparacion.new, usuario_pedido, 250, 3, fecha_no_lluvia, api_clima)
      pedido.cancelar(usuario_pedido)
      expect(pedido.estado.id).to eq 'cancelado'
    end

    it 'un pedido en espera deberia poder ser cancelado' do
      pedido = described_class.crear('Menu familiar', EstadoPedidoEnEspera.new, usuario_pedido, 250, 3, fecha_no_lluvia, api_clima)
      pedido.cancelar(usuario_pedido)
      expect(pedido.estado.id).to eq 'cancelado'
    end

    it 'un pedido deberia crearse con la fecha de hoy' do
      pedido = described_class.crear('Menu familiar',EstadoPedidoRecibido.new,usuario_pedido, 250, 3, fecha_no_lluvia, api_clima)
      expect(pedido.fecha).to eq fecha_no_lluvia.hoy
    end

    it 'deberia devolver un mensaje de error cuando se intenta cancelar un pedido en camino' do
      usuario_dueno = Usuario.new('un_usuario', 'nombre', 'direccion', '12345678', 1)
      pedido = described_class.new('Menu parejas', EstadoPedidoEnCamino.new, usuario_dueno, 175, 2, 5)
      expect{pedido.cancelar(usuario_dueno)}.to raise_error PedidoYaEnCamino
    end

    it 'deberia devolver un mensaje de error cuando se intenta cancelar un pedido entregado' do
      usuario_dueno = Usuario.new('un_usuario', 'nombre', 'direccion', '12345678', 1)
      pedido = described_class.new('Menu parejas', EstadoPedidoEntregado.new, usuario_dueno, 175, 2, 5)
      expect{pedido.cancelar(usuario_dueno)}.to raise_error PedidoYaEntregado
    end

    it 'deberia devolver un mensaje de error cuando se intenta calificar fuera del rango 1 a 5' do
      usuario_dueno = Usuario.new('un_usuario', 'nombre', 'direccion', '12345678', 1)
      pedido = described_class.new('Menu parejas', EstadoPedidoEntregado.new, usuario_dueno, 175, 2)
      expect{pedido.calificar(usuario_dueno,6)}.to raise_error ValorDeCalificacionInvalido
    end
  end
end
