require 'spec_helper'

describe 'CalculadorAlquilerCuit' do
  let(:calculador_cuit) { CalculadorAlquilerCuit.new }

  it 'con un precio base de 100 y un cuit con descuento el precio final es 95' do
    expect(calculador_cuit.calcular_importe('264873215', 100)).to eq 95 
  end

  it 'con un precio base de 1000 y un cuit sin descuento el precio final es 1000' do
    expect(calculador_cuit.calcular_importe('286421-45', 1000)).to eq 1000
  end

  it 'con un precio base de 0 y un cuit con descuento el precio final es 0' do
    expect(calculador_cuit.calcular_importe('26784/45', 0)).to eq 0
  end

end
