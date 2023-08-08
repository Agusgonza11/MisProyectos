require 'spec_helper'
require 'date'

describe ApiClima do
  it 'deberia poder consultar el clima' do
    fecha = Date.new(2022,11,12)
    expect(ApiClima.instance.clima(fecha)).to eq 'light rain shower'
  end
end

