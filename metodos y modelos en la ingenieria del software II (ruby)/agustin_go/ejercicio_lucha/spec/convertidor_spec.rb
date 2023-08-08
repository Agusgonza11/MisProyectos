require 'spec_helper'

describe 'Convertidor' do
  let(:convertidor) { Convertidor.new }

  it 'el string humano es convertido en objeto Humano' do
    expect(convertidor.convertir_luchador('humano').class).to eq Humano.new.class
  end

  it 'el string vampiro es convertido en objeto Vampiro' do
    expect(convertidor.convertir_luchador('vampiro').class).to eq Vampiro.new.class
  end

  it 'el string lobo es convertido en objeto Lobo' do
    expect(convertidor.convertir_luchador('lobo').class).to eq Lobo.new.class
  end

  it 'si ingreso un luchador inexistente devuelve un -1' do
    expect(convertidor.convertir_luchador('goku ssj')).to eq -1
  end

  it 'el string mano es convertido en objeto mano' do
    expect(convertidor.convertir_arma('mano').class).to eq Mano.new.class
  end

  it 'el string espada es convertido en objeto espada' do
    expect(convertidor.convertir_arma('espada').class).to eq Espada.new.class
  end

  it 'el string cuchillo es convertido en objeto cuchillo' do
    expect(convertidor.convertir_arma('cuchillo').class).to eq Cuchillo.new.class
  end

  it 'si ingreso un arma inexistente devuelve un -1' do
    expect(convertidor.convertir_luchador('katana')).to eq -1
  end

end
