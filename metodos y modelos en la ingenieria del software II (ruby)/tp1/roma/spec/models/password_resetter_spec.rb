require 'spec_helper'

describe PasswordResetter do
  let(:password_resetter) { described_class.new('offerer@test.com') }

  describe 'valid recovery code' do
    it 'should be 8 alphanumeric characters long' do
      expect(password_resetter.recovery_code).to match(/\w{8}/)
    end
  end

  describe 'process' do
    it 'should deliver recovery code' do
      expect(JobVacancy::App).to receive(:deliver).with(:notification, :recovery_code_email, password_resetter)
      password_resetter.process
    end
  end
end
