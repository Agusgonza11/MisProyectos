require 'spec_helper'
require_relative '../app/models/pedido.rb'

describe Pedido do
  subject(:pedido) { described_class.new('1', 'Menu Individual', '1234', 'recibido') }

  describe 'model' do
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:nombre) }
    it { is_expected.to respond_to(:usuario) }
    it { is_expected.to respond_to(:estado) }
    it { is_expected.to respond_to(:calificacion) }
    it { is_expected.to respond_to(:comentario) }
  end
end
