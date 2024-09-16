require 'spec_helper'

describe 'FabricaVehiculos' do
  it 'fabricar un auto deberia devolver un objeto auto' do
    expect(FabricaVehiculos.fabricar('auto')).to be_a(Auto)
  end

  it 'fabricar una camioneta deberia devolver un objeto camioneta' do
    expect(FabricaVehiculos.fabricar('camioneta')).to be_a(Camioneta)
  end

  it 'fabricar un camion deberia devolver un objeto camion' do
    expect(FabricaVehiculos.fabricar('camion')).to be_a(Camion)
  end

  it 'fabricar un vehiculo inexistente deberia devolver un error' do
    expect{FabricaVehiculos.fabricar('ferrari')}.to raise_error VehiculoInvalido 
  end
end