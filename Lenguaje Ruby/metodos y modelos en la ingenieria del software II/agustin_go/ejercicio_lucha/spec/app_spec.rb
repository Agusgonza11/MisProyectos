require 'rspec'

describe 'App' do

  it '01-Humano-con-espada vs Humano-con-espada en estadio => empate' do
    result = `ruby app.rb estadio humano espada humano espada`
    expect(result.strip).to eq 'Resultado: empate'
  end

  it '02-Humano-con-espada vs Humano-con-mano en estadio => gana 1' do
    result = `ruby app.rb estadio humano espada humano mano`
    expect(result.strip).to eq 'Resultado: gana 1'
  end

  it '03-Humano-con-mano vs Lobo-con-mano en estadio => gana 2' do
    result = `ruby app.rb estadio humano mano lobo mano`
    expect(result.strip).to eq 'Resultado: gana 2'
  end

  it '04-Humano-con-espada vs Lobo-con-mano en ciudad => gana 1' do
    result = `ruby app.rb ciudad humano espada lobo mano`
    expect(result.strip).to eq 'Resultado: gana 2'
  end

  it '05-Vampiro-con-espada vs Lobo-con-mano en noche => gana 1' do
    result = `ruby app.rb noche vampiro espada lobo mano`
    expect(result.strip).to eq 'Resultado: gana 1'
  end

  it '06-Vampiro-con-cuchillo vs Lobo-con-mano en lluvia => gana 2' do
    result = `ruby app.rb lluvia vampiro cuchillo lobo mano`
    expect(result.strip).to eq 'Resultado: gana 2'
  end

  it '07- escenario desconocido lanza error' do
    result = `ruby app.rb ningun_lugar humano mano humano mano`
    expect(result.strip).to eq 'error: escenario desconocido'
  end

end
