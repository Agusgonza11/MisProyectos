require 'spec_helper'

describe PasswordValidator do
  subject(:validator) { described_class.new }

  describe 'valid password' do
    it 'should be valid when the password is SADAmkflsma123' do
      expect(validator.validate_password('SADAmkflsma123').errors.empty?).to eq true
    end
  end

  describe 'invalid password' do
    it 'should be invalid when the password is SAda123 because is too short' do
      error_message = validator.validate_password('SAda123').errors[0]
      expect(error_message).to eq 'too short'
    end

    it 'should be invalid when the password is SAdaMKSMDOQa because it does not have numbers' do
      error_message = validator.validate_password('SAdaMKSMDOQa').errors[0]
      expect(error_message).to eq 'missing number'
    end

    it 'should be invalid when the password is daa213dkaof41 because it does not have uppercase characters' do
      error_message = validator.validate_password('daa213dkaof41').errors[0]
      expect(error_message).to eq 'missing uppercase'
    end

    it 'should be invalid when the password is EXZ213ABCD41 because it does not have lowercase characters' do
      error_message = validator.validate_password('EXZ213ABCD41').errors[0]
      expect(error_message).to eq 'missing lowercase'
    end
  end
end
