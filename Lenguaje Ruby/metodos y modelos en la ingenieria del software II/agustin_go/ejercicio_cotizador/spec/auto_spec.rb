require 'spec_helper'

describe 'Auto' do
  let(:auto) { Auto.new }

  it 'cotizar un auto con 1000 cilindradas y 1000 kilometros deberia tener un coeficiente impositivo de 1' do
    expect(auto.cotizar(Cilindrada.new(1000), 1000)[0]).to eq 1 
  end

  it 'cotizar un auto con 1000 cilindradas y 1000 kilometros deberia tener un valor de mercado de 500.0' do
    expect(auto.cotizar(Cilindrada.new(1000), 1000)[1]).to eq 500.0
  end

  it 'cotizar un auto con 1600 cilindradas y 0 kilometros deberia tener un coeficiente impositivo de 1 y un valor de mercado de 1000.0' do
    expect(auto.cotizar(Cilindrada.new(1600), 0)[0]).to eq 1
    expect(auto.cotizar(Cilindrada.new(1600), 0)[1]).to be_within(0.1).of(1000.0)
  end

  it 'cotizar un auto con 2000 cilindradas y 85 kilometros deberia tener un coeficiente impositivo de 2 y un valor de mercado de 1843.3' do
    expect(auto.cotizar(Cilindrada.new(2000), 85)[0]).to eq 2
    expect(auto.cotizar(Cilindrada.new(2000), 85)[1]).to be_within(0.1).of(1843.3)
  end

  it 'calcular el valor de mercado de un auto con coeficiente impositivo 2 con 1600 cilindradas y 10 kilometros deberia ser 1980.1' do
    expect(auto.calcular_valor_mercado(2, Cilindrada.new(1600), 10)).to be_within(0.1).of(1980.1)
  end

  it 'cotizar un auto con kilometraje invalido deberia devolver un error' do
    expect{auto.cotizar(Cilindrada.new(2000), -55)}.to raise_error KilometrajeInvalido 
  end
end
