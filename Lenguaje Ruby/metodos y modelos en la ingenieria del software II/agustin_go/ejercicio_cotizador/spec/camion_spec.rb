require 'spec_helper'

describe 'Camion' do
  let(:camion) { Camion.new }

  it 'cotizar un camion con 1000 cilindradas y 1000 kilometros deberia tener un coeficiente impositivo de 1' do
    expect(camion.cotizar(Cilindrada.new(1000), 1000)[0]).to eq 2
  end

  it 'cotizar un camion con 1600 cilindradas y 50000 kilometros deberia tener un valor de mercado de 500.0' do
    expect(camion.cotizar(Cilindrada.new(1600), 50000)[1]).to be_within(0.1).of(58.1)
  end

  it 'cotizar un camion con 2000 cilindradas y 0 kilometros deberia tener un coeficiente impositivo de 1 y un valor de mercado de 1000.0' do
    expect(camion.cotizar(Cilindrada.new(2000), 0)[0]).to eq 4
    expect(camion.cotizar(Cilindrada.new(2000), 0)[1]).to eq 2000.0
  end

  it 'calcular el valor de mercado de un camion con coeficiente impositivo 2 con 1600 cilindradas y 10 kilometros deberia ser 1242.2' do
    expect(camion.calcular_valor_mercado(2, Cilindrada.new(1600), 10)).to be_within(0.1).of(1242.2)
  end

  it 'cotizar un camion con kilometraje invalido deberia devolver un error' do
    expect{camion.cotizar(Cilindrada.new(2000), -10000)}.to raise_error KilometrajeInvalido 
  end
end