require 'spec_helper'

describe 'Lucha' do
  let(:lucha) { Lucha.new }

  it 'cuando hay un escenario inexistente se informa del error' do
    expect(lucha.obtener_ganador('hollywood', 'lobo', 'mano', 'vampiro', 'espada')).to eq 'escenario desconocido' 
  end

  it 'cuando hay un arma inexistente se informa del error' do
    expect(lucha.obtener_ganador('estadio', 'lobo', 'mano', 'vampiro', 'sable')).to eq 'arma desconocida' 
  end

  it 'cuando hay un personaje inexistente se informa del error' do
    expect(lucha.obtener_ganador('estadio', 'lobo', 'mano', 'tortuga', 'mano')).to eq 'personaje desconocido' 
  end

  it 'cuando hay dos armas inexistentes se informa del error' do
    expect(lucha.obtener_ganador('estadio', 'pistola', 'mano', 'vampiro', 'metralleta')).to eq 'arma desconocida' 
  end

  it 'cuando en una ciudad pelean un lobo en bosque y un vampiro con espada gana el lobo' do
    expect(lucha.obtener_ganador('bosque', 'lobo', 'mano', 'vampiro', 'espada')).to eq 'gana 1' 
  end

  it 'cuando en una ciudad pelean un humano con mano y un vampiro con mano, empatan' do
    expect(lucha.obtener_ganador('ciudad', 'humano','espada' ,'vampiro', 'mano')).to eq 'empate' 
  end

  it 'cuando en lluvia pelean un humano con mano y un vampiro con mano, gana el humano' do
    expect(lucha.obtener_ganador('lluvia', 'humano','cuchillo' ,'vampiro', 'mano')).to eq 'gana 1' 
  end

  it 'cuando en una ciudad pelean un humano con cuchillo y un vampiro con mano, gana el gana el humano' do
    expect(lucha.obtener_ganador('ciudad', 'humano', 'cuchillo','vampiro', 'mano')).to eq 'gana 1' 
  end

  it 'cuando en una noche pelean um vampiro y un lobo, empatan' do
    expect(lucha.obtener_ganador('noche', 'vampiro','mano' ,'lobo', 'mano')).to eq 'empate' 
  end

  it 'cuando en un estadio pelean dos humanos con mano, el resultado es un empate' do
    expect(lucha.obtener_ganador('estadio', 'humano','mano' ,'humano', 'mano')).to eq 'empate' 
  end

  it 'cuando en un estadio pelean un humano con cuchillo y un lobo con mano, gana el lobo' do
    expect(lucha.obtener_ganador('estadio', 'humano', 'cuchillo', 'lobo', 'mano')).to eq 'gana 2' 
  end

  it 'cuando en un estadio pelean un lobo con cuchillo y un vampiro con espada, gana el lobo' do
    expect(lucha.obtener_ganador('estadio', 'lobo', 'cuchillo', 'vampiro', 'espada')).to eq 'gana 1' 
  end

  it 'cuando en un estadio pelean un vampiro con mano y un humano con espada, gana el humano' do
    expect(lucha.obtener_ganador('estadio', 'vampiro', 'mano', 'humano', 'espada')).to eq 'gana 1' 
  end
end
