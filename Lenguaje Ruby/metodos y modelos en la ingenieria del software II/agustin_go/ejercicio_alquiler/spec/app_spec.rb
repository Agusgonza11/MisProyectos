require 'spec_helper'

describe 'App' do
  let(:app) { App.new }

  it 'alquilar un auto tres horas vale 300' do
    expect(app.calcular_importe('h', 3, '20112223336', '20190119', '20190119')).to eq 300 
  end

  it 'alquilar un auto cinco horas vale 500' do
    expect(app.calcular_importe('h', 5, '4545-745', '20190101', '20190101')).to eq 500 
  end

  it 'alquilar un auto cinco horas con un descuento de empresa vale 475' do
    expect(app.calcular_importe('h', 5, '267895135-5', '20190101', '20190101')).to eq 475 
  end

  it 'alquilar un auto cinco dias vale 10000' do
    expect(app.calcular_importe('d', 5, 'asd4856-23', '20190101', '20190101')).to eq 10000
  end

  it 'alquilar un auto por 500km vale 5100' do
    expect(app.calcular_importe('k', 500, '564232', '20190101', '20190101')).to eq 5100
  end

  it 'alquilar un auto 5 horas y entregarlo atrasado vale 1000' do
    expect(app.calcular_importe('h', 5, '4545-745', '20190101', '20190102')).to eq 1000
  end

  it 'alquilar un auto cinco horas con un descuento de empresa y entregarlo atrasado vale 950' do
    expect(app.calcular_importe('h', 5, '267895135-5', '20190101', '20190108')).to eq 950
  end

  it 'alquilar un auto cinco dias y entregarlo atrasado vale 20000' do
    expect(app.calcular_importe('d', 5, 'asd4856-23', '20190101', '20190201')).to eq 20000
  end

  it 'alquilar un auto por 500km y entregarlo atrasado vale 10200' do
    expect(app.calcular_importe('k', 500, '564232', '20190101', '20190102')).to eq 10200
  end
end
