require 'spec_helper'

describe 'FabricaCilindrada' do
  it 'fabricar una cilindrada de 1000 deberia devolver un objeto cilindrada' do
    expect(FabricaCilindrada.fabricar('1000')).to be_a(Cilindrada)
  end

  it 'fabricar una cilindrada de 1600 deberia devolver un objeto cilindrada' do
    expect(FabricaCilindrada.fabricar('1600')).to be_a(Cilindrada)
  end

  it 'fabricar una cilindrada de 2000 deberia devolver un objeto cilindrada' do
    expect(FabricaCilindrada.fabricar('2000')).to be_a(Cilindrada)
  end

  it 'fabricar una cilindrada inexistente deberia devolver un error' do
    expect{FabricaCilindrada.fabricar('2500')}.to raise_error CilindradaInvalida 
  end
end