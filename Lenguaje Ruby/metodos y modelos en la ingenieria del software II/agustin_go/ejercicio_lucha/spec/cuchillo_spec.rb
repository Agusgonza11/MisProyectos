require 'spec_helper'

describe 'Cuchillo' do
  let(:cuchillo) { Cuchillo.new }

  it 'el puntaje suma 2 con un cuchillo como arma' do
    expect(cuchillo.calcular_puntaje(10)).to eq 12
  end

end
