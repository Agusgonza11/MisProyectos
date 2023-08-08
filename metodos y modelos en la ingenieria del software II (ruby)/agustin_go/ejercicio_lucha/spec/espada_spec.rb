require 'spec_helper'

describe 'Espada' do
  let(:espada) { Espada.new }

  it 'el puntaje se multiplica por dos con una espada como arma' do
    expect(espada.calcular_puntaje(10)).to eq 20
  end

end
