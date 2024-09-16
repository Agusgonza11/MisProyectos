require 'spec_helper'
require_relative '../app/models/usuario.rb'

describe Usuario do
  subject(:usuario) { described_class.new('us1', 'Hernan') }

  describe 'model' do
    it { is_expected.to respond_to(:nombre_usuario) }
    it { is_expected.to respond_to(:nombre) }
  end
end
