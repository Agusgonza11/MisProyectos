require 'spec_helper'
require 'date'

describe LaNonna do
  subject(:nonna) { described_class.new([]) }
  let(:fecha_no_lluvia) { instance_double('Fecha', hoy: Date.new(2022,11,19)) }
  let(:api_clima) { instance_double('ApiClima', clima: 'soleado') }

  describe 'establecer repartidor' do
    it 'un pedido recibido deberia cambiar a en_preparacion' do
      repartidor = Repartidor.new('hernancapo123', 'hernan', 1)
      la_nonna = described_class.new([repartidor])
      pedido = Pedido.crear('Menu familiar', EstadoPedidoRecibido.new, 'u1', 250, 3, fecha_no_lluvia, api_clima)
      la_nonna.asignar_repartidor(pedido)
      expect(pedido.repartidor).to eq repartidor
    end

    it 'deberia lanzar NoHayRepartidores si no tiene repartidores' do
      la_nonna = described_class.new([])
      pedido = Pedido.crear('Menu familiar', EstadoPedidoEnPreparacion.new, 'u1', 250, 3, fecha_no_lluvia, api_clima)
      expect{la_nonna.asignar_repartidor(pedido)}.to raise_error NoHayRepartidores
    end

    it 'un pedido individual sin calificacion deberia tener comision 5' do
      pedido = Pedido.crear('Menu individual', EstadoPedidoEntregado.new, 'u1', 100, 1, fecha_no_lluvia, api_clima)
      expect(described_class.calcular_comision([pedido], Contador.new)).to eq 5
    end

    it 'un pedido parejas y un pedido familiar sin calificacion deberia tener comision 21.25' do
      pedido_parejas = Pedido.crear('Menu parejas', EstadoPedidoEntregado.new, 'u1', 175, 2, fecha_no_lluvia, api_clima)
      pedido_familiar = Pedido.crear('Menu familiar', EstadoPedidoEntregado.new, 'u1', 250, 3, fecha_no_lluvia, api_clima)
      expect(described_class.calcular_comision([pedido_parejas, pedido_familiar], Contador.new)).to eq 21.25
    end

    it 'deberia lanzar CalificacionesPendientes si tiene pedidos entregados sin calificar' do
      pedido_parejas = Pedido.crear('Menu parejas', EstadoPedidoEntregado.new, 'u1', 175, 2, fecha_no_lluvia, api_clima)
      pedido_familiar = Pedido.crear('Menu familiar', EstadoPedidoEntregado.new, 'u1', 250, 3, fecha_no_lluvia, api_clima)
      expect{described_class.validar_calificaciones_pendientes([pedido_parejas, pedido_familiar])}.to raise_error CalificacionesPendientes
    end

    it 'no deberia lanzar CalificacionesPendientes si no tiene pedidos entregados sin calificar' do
      expect{described_class.validar_calificaciones_pendientes([])}.not_to raise_error CalificacionesPendientes
    end
  end
end
