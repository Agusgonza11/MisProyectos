require 'spec_helper'

describe 'Buscador' do
  let(:buscador) { Buscador.new }

  it 'encontrar un 3 en arreglo vacio deberia ser -1' do
    expect(buscador.encontrar(3, [])).to eq -1 # rubocop:disable Lint/AmbiguousOperator
  end

  it 'encontrar un 3 en arreglo [3,5,1000] deberia ser 0' do
    expect(buscador.encontrar(3, [3,5,1000])).to eq 0
  end

  it 'encontrar 15 en arreglo [0,0,150,100000,15] deberia ser 4' do
    expect(buscador.encontrar(15, [0,0,150,100000,15])).to eq 4
  end
end
