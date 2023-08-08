require 'spec_helper'

describe 'CalculadorAlquilerTipo' do
  let(:calculador_tipo) { CalculadorAlquilerTipo.new }

  it 'alquilar un auto cinco horas vale 500' do
    expect(calculador_tipo.calcular_importe('h', 5)).to eq 500 
  end

  it 'alquilar un auto cero horas vale 0' do
    expect(calculador_tipo.calcular_importe('h', 0)).to eq 0
  end

  it 'alquilar un auto cinco dias vale 10000' do
    expect(calculador_tipo.calcular_importe('d', 5)).to eq 10000
  end

  it 'alquilar un auto por 500km vale 5100' do
    expect(calculador_tipo.calcular_importe('k', 500)).to eq 5100
  end

  it 'alquilar un auto por 0km vale 100' do
    expect(calculador_tipo.calcular_importe('k', 0)).to eq 100
  end
end
