require 'spec_helper'
require 'date'

describe 'Contador' do
  describe 'calcular comision de un pedido' do
    let(:clima_soleado) { 'sunny' }
    let(:clima_lluvioso) { 'rain' }

    it 'deberia devolver 5 como comision para un pedido individual sin calificacion' do
      contador = Contador.new
      expect(contador.calcular_comision(100, nil, clima_soleado)).to be_within(0.01).of(5)
    end

    it 'deberia devolver 5 como comision para un pedido individual con calificacion 3' do
      contador = Contador.new
      expect(contador.calcular_comision(100, 3, clima_soleado)).to be_within(0.01).of(5)
    end

    it 'deberia devolver 7 como comision para un pedido individual con calificacion 5' do
      contador = Contador.new
      expect(contador.calcular_comision(100, 5, clima_soleado)).to be_within(0.01).of(7)
    end

    it 'deberia devolver 3 como comision para un pedido individual con calificacion 1' do
      contador = Contador.new
      expect(contador.calcular_comision(100, 1, clima_soleado)).to be_within(0.01).of(3)
    end

    it 'deberia devolver 10 como comision para un pedido familiar con calificacion 1 y lluvia' do
      contador = Contador.new
      expect(contador.calcular_comision(250, 1, clima_lluvioso)).to be_within(0.01).of(10)
    end
  end
end
