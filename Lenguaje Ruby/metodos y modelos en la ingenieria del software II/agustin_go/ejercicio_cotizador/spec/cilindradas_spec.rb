require 'spec_helper'

describe 'Cilindrada' do
  it 'calcular el coeficiente impositovo de una cilindrada de 1600 con un precio base de 1000 deberia ser 1' do
    cilindrada = Cilindrada.new(1600)
    expect(cilindrada.calcular_coeficiente(1000)).to eq 1
  end

  it 'calcular el coeficiente impositovo de una cilindrada de 2000 con un precio base de 2000 deberia ser 1' do
    cilindrada = Cilindrada.new(2000)
    expect(cilindrada.calcular_coeficiente(2000)).to eq 4
  end

  it 'calcular el valor de una cilindrada de 1000 con un kilometraje de 0 deberia ser 1000' do
    cilindrada = Cilindrada.new(1000)
    expect(cilindrada.calcular_valor(0)).to eq 1000
  end

  it 'calcular el valor de una cilindrada de 2000 con un kilometraje de 100 deberia ser 2100' do
    cilindrada = Cilindrada.new(2000)
    expect(cilindrada.calcular_valor(100)).to eq 2100
  end
end