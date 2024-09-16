require 'spec_helper'

describe ValidationResult do
  subject(:error_no_numbers) { 'Password should have at least 1 number' }

  let(:validation_result) { described_class.new }

  let(:error_too_short) { 'Password should be at least 10 characters long' }

  describe 'validation' do
    it 'should be true when there are no errors' do
      expect(validation_result.is_valid?).to eq true
    end

    it 'should be false when there is an error' do
      validation_result.add_validation(:error_too_short)
      expect(validation_result.is_valid?).to eq false
    end

    it 'should return the message for short password when it does not pass the validation' do
      validation_result.add_validation(:error_too_short)
      expect(validation_result.errors).to eq [:error_too_short]
    end

    it 'should return multiple message errors when it does not pass the validation' do
      validation_result.add_validation(:error_too_short)
      validation_result.add_validation(:error_no_numbers)
      expect(validation_result.errors).to eq %i[error_too_short error_no_numbers]
    end
  end
end
