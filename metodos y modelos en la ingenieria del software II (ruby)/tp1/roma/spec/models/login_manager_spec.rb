require 'spec_helper'

describe LoginManager do
  let(:login_manager) { described_class.new }
  let(:expected_password) { 'ABCDefdh123' }
  let(:first_wrong_password) { 'ABCD' }
  let(:second_wrong_password) { '5493280asfasA' }
  let(:third_wrong_password) { 'IOIOJFDA38' }

  describe 'invalid access count' do
    it 'should be 0 when the compared passwords match' do
      received_password = 'ABCDefdh123'
      login_manager.compare_passwords(received_password == expected_password)
      expect(login_manager.failed_attempts).to eq 0
    end

    it 'should be 1 when the compared passwords do not match' do
      received_password = 'ABCD'
      login_manager.compare_passwords(received_password == expected_password)
      expect(login_manager.failed_attempts).to eq 1
    end

    it 'should be 3 when the compared passwords do not match 3 times' do
      login_manager.compare_passwords(first_wrong_password == expected_password)
      login_manager.compare_passwords(second_wrong_password == expected_password)
      login_manager.compare_passwords(third_wrong_password == expected_password)
      expect(login_manager.failed_attempts).to eq 3
    end

    it 'should be 0 when the compared passwords do not match 2 times but does match the last time' do
      last_password = 'ABCDefdh123'
      login_manager.compare_passwords(first_wrong_password == expected_password)
      login_manager.compare_passwords(second_wrong_password == expected_password)
      login_manager.compare_passwords(last_password == expected_password)
      expect(login_manager.failed_attempts).to eq 0
    end
  end

  describe 'invalid access in a blocked account' do
    it 'should be blocked when have 3 failed attempts' do
      login_manager.compare_passwords(first_wrong_password == expected_password)
      login_manager.compare_passwords(second_wrong_password == expected_password)
      login_manager.compare_passwords(third_wrong_password == expected_password)
      expect(login_manager.is_blocked?).to eq true
    end
  end
end
