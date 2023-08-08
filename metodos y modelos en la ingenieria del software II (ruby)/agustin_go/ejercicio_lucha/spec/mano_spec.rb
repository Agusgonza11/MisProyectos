require 'spec_helper'

describe 'Mano' do
  let(:mano) { Mano.new }

  it 'el puntaje no modifica con una mano como arma' do
    expect(mano.calcular_puntaje(10)).to eq 10
  end

end
