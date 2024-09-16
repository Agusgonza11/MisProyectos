require 'spec_helper'

describe 'Sumador' do
  let(:sumador) { Sumador.new }

  it 'sumar de [] deberia ser vacio' do
    expect(sumador.sumar([])).to eq 'vacio'
  end

  it 'sumar de [1] deberia ser uno' do
    expect(sumador.sumar([1])).to eq 'uno'
  end

  it 'sumar de [1,6] deberia ser siete' do
    expect(sumador.sumar([1, 6])).to eq 'siete'
  end

  it 'sumar de [24,8] deberia ser uno,ocho' do
    expect(sumador.sumar([24, 8])).to eq 'tres,dos'
  end

  it 'sumar de [100,100] deberia ser demasiado grande' do
    expect(sumador.sumar([100, 100])).to eq 'demasiado grande'
  end

  it 'sumar de [50,49] deberia ser nueve,nueve' do
    expect(sumador.sumar([50, 49])).to eq 'nueve,nueve'
  end

  it 'sumar de [44] deberia ser cuatro,cuatro' do
    expect(sumador.sumar([44])).to eq 'cuatro,cuatro'
  end

  it 'sumar de [20,1,1,1] deberia ser dos,tres' do
    expect(sumador.sumar([20, 1, 1, 1])).to eq 'dos,tres'
  end

  it 'convertir el digito 0 deberia dar un array [0]' do
    expect(sumador.convertir_suma_doble_digito(0)).to eq [0]
  end

  it 'convertir la suma de doble digito 12 deberia dar un array [1,2]' do
    expect(sumador.convertir_suma_doble_digito(12)).to eq [1,2]
  end

  it 'convertir la suma de doble digito 4891 deberia dar un array [4,8,9,1]' do
    expect(sumador.convertir_suma_doble_digito(4891)).to eq [4,8,9,1]
    #aunque no es necesaria para la funcion chopper muestro que sumador puede convertir mas de 2 cifras
  end
end
