require 'spec_helper'

describe 'Lobo' do
  let(:lobo) { Lobo.new }

  it 'el puntaje de un lobo en un estadio es 3' do
    expect(lobo.puntaje_por_escenario('estadio')).to eq 3 
  end

  it 'el puntaje de un lobo en un ciudad es 3' do
    expect(lobo.puntaje_por_escenario('ciudad')).to eq 3
  end

  it 'el puntaje de un lobo en una noche es 3' do
    expect(lobo.puntaje_por_escenario('noche')).to eq 3
  end

  it 'el puntaje de un lobo en con lluvia es 3' do
    expect(lobo.puntaje_por_escenario('lluvia')).to eq 3
  end

  it 'el puntaje de un lobo en bosque es 9' do
    expect(lobo.puntaje_por_escenario('bosque')).to eq 9
  end

  it 'el puntaje de un lobo en con espada es 6' do
    expect(lobo.puntaje_por_arma(Espada.new)).to eq 6
  end

  it 'el puntaje de un lobo en con mano es 3' do
    expect(lobo.puntaje_por_arma(Mano.new)).to eq 3
  end

  it 'el puntaje de un lobo en con cuchillo es 5' do
    expect(lobo.puntaje_por_arma(Cuchillo.new)).to eq 5
  end

end
