require 'spec_helper'

describe 'Camioneta' do
  let(:camioneta) { Camioneta.new }

  it 'cotizar una camioneta con 1600 cilindradas y 500 kilometros deberia tener un coeficiente impositivo de 1' do
    expect(camioneta.cotizar(Cilindrada.new(1600), 500)[0]).to eq 2
  end

  it 'cotizar una camioneta con 1600 cilindradas y 500 kilometros deberia tener un valor de mercado de 500' do
    expect(camioneta.cotizar(Cilindrada.new(1600), 500)[1]).to be_within(0.1).of(1428.6)
  end

  it 'cotizar una camioneta con 2000 cilindradas y 50 kilometros deberia tener un coeficiente impositivo de 3 y un valor de mercado de 2195.1' do
    expect(camioneta.cotizar(Cilindrada.new(2000), 50)[0]).to eq 3
    expect(camioneta.cotizar(Cilindrada.new(2000), 50)[1]).to be_within(0.1).of(2195.1)
  end
  
  it 'calcular el valor de mercado de una camioneta con coeficiente impositivo 2 con 1600 cilindradas y 10 kilometros deberia ser 1863.3' do
    expect(camioneta.calcular_valor_mercado(2, Cilindrada.new(1600), 10)).to be_within(0.1).of(1863.3)
  end

  it 'cotizar una camioneta con kilometraje invalido deberia devolver un error' do
    expect{camioneta.cotizar(Cilindrada.new(2000), -1)}.to raise_error KilometrajeInvalido 
  end
end