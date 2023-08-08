require 'spec_helper'

describe 'Humano' do
  let(:humano) { Humano.new }

  it 'el puntaje de un humano en un estadio es 1' do
    expect(humano.puntaje_por_escenario('estadio')).to eq 1 
  end

  it 'el puntaje de un humano en una noche es 1' do
    expect(humano.puntaje_por_escenario('noche')).to eq 1 
  end

  it 'el puntaje de un humano en una ciudad es 2' do
    expect(humano.puntaje_por_escenario('ciudad')).to eq 2
  end

  it 'el puntaje de un humano en lluvia es 1' do
    expect(humano.puntaje_por_escenario('lluvia')).to eq 1
  end

  it 'el puntaje de un humano en bosque es 1' do
    expect(humano.puntaje_por_escenario('bosque')).to eq 1
  end

  it 'el puntaje de un humano en con espada es 2' do
    expect(humano.puntaje_por_arma(Espada.new)).to eq 2
  end

  it 'el puntaje de un humano en con mano es 1' do
    expect(humano.puntaje_por_arma(Mano.new)).to eq 1
  end

  it 'el puntaje de un humano en con cuchillo es 3' do
    expect(humano.puntaje_por_arma(Cuchillo.new)).to eq 3
  end

end
