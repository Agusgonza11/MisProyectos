require 'spec_helper'

describe 'Vampiro' do
  let(:vampiro) { Vampiro.new }

  it 'el puntaje de un vampiro en un estadio es 2' do
    expect(vampiro.puntaje_por_escenario('estadio')).to eq 2 
  end

  it 'el puntaje de un vampiro en un ciudad es 2' do
    expect(vampiro.puntaje_por_escenario('ciudad')).to eq 2 
  end

  it 'el puntaje de un vampiro en una noche es 4' do
    expect(vampiro.puntaje_por_escenario('noche')).to eq 4
  end

  it 'el puntaje de un vampiro en con lluvia es 1' do
    expect(vampiro.puntaje_por_escenario('lluvia')).to eq 1
  end

  it 'el puntaje de un vampiro en con lluvia es 1' do
    expect(vampiro.puntaje_por_escenario('bosque')).to eq 2
  end

  it 'el puntaje de un vampiro en con espada es 4' do
    expect(vampiro.puntaje_por_arma(Espada.new)).to eq 4
  end

  it 'el puntaje de un vampiro en con mano es 2' do
    expect(vampiro.puntaje_por_arma(Mano.new)).to eq 2
  end

  it 'el puntaje de un vampiro en con cuchillo es 4' do
    expect(vampiro.puntaje_por_arma(Cuchillo.new)).to eq 4
  end
end
