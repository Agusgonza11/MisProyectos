require 'spec_helper'

describe Usuario do
  subject(:usuario) { described_class.new('nombre_telegram', 'Hernan', 'Paseo Colon 850', '12345678') }

  describe 'model' do
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:nombre_usuario) }
    it { is_expected.to respond_to(:nombre) }
    it { is_expected.to respond_to(:direccion) }
    it { is_expected.to respond_to(:telefono) }
  end
end
