require 'spec_helper'

describe 'CalculadorAlquilerTiempo' do
  let(:calculador_tiempo) { CalculadorAlquilerTiempo.new }

  it 'con un precio base de 500 y una entrega a tiempo el alquiler no sufre recargo' do
    expect(calculador_tiempo.calcular_importe('20220828', '20220828', 'h', 22, 500)).to eq 500
  end

  it 'con un precio base de 500 y una entrega atrasada el alquiler sufre recargo' do
    expect(calculador_tiempo.calcular_importe('20220828', '20220829', 'h', 23, 500)).to eq 1000
  end

  it 'con un precio base de 1000 y un alquiler por kilometraje atrasado se sufre recargo' do
    expect(calculador_tiempo.calcular_importe('20220828', '20220829', 'k', 10, 1000)).to eq 2000
  end

  it 'con un precio base de 100 y una entrega a tiempo no se sufre recargo' do
    expect(calculador_tiempo.calcular_importe('20220828', '20220903', 'd', 10, 100)).to eq 100
  end

  it 'con un precio base de 100 y una entrega a tiempo no se sufre recargo' do
    expect(calculador_tiempo.calcular_importe('20220828', '20220909', 'd', 10, 100)).to eq 200
  end

  it 'con una fecha de alquiler 2022-08-28 al sumarle 5 horas la fecha permanece igual' do
    expect(calculador_tiempo.calcular_tiempo_transcurrido(DateTime.new(2022,9,9), 'h', 5)).to eq DateTime.new(2022,9,9)
  end

  it 'con una fecha de alquiler 2022-08-28 al sumarle 25 horas la fecha aumenta un dia' do
    expect(calculador_tiempo.calcular_tiempo_transcurrido(DateTime.new(2022,9,9), 'h', 25)).to eq DateTime.new(2022,9,10)
  end

  it 'con una fecha de alquiler 2022-08-28 al sumarle 1 dia la fecha aumenta un dia' do
    expect(calculador_tiempo.calcular_tiempo_transcurrido(DateTime.new(2022,9,9), 'd', 1)).to eq DateTime.new(2022,9,10)
  end

  it 'con una fecha de alquiler 2022-08-28 al sumarle 50 dias la fecha aumenta 50 dias' do
    expect(calculador_tiempo.calcular_tiempo_transcurrido(DateTime.new(2022,9,9), 'd', 50)).to eq DateTime.new(2022,10,29)
  end

  it 'con una fecha de alquiler 2022-08-28 al sumarle kilometros la fecha no cambia' do
    expect(calculador_tiempo.calcular_tiempo_transcurrido(DateTime.new(2022,9,9), 'k', 100)).to eq DateTime.new(2022,9,9)
  end
end
