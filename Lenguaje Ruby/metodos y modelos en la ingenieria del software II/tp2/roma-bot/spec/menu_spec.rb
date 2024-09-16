require 'spec_helper'
require_relative '../app/models/menu.rb'

describe Menu do
  subject(:menu) { described_class.new(1, 'Menu individual', 100) }

  describe 'model' do
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:nombre) }
    it { is_expected.to respond_to(:precio) }
  end
end
