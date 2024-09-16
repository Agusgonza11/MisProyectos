require 'spec_helper'

describe User do
  subject(:user) { described_class.new({}) }

  describe 'model' do
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:crypted_password) }
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:job_offers) }
    it { is_expected.to respond_to(:subscription) }
  end

  describe 'valid?' do
    it 'should be false when name is blank' do
      user = described_class.new(email: 'john.doe@someplace.com',
                                 crypted_password: 'a_secure_passWord!')
      expect(user.valid?).to eq false
      expect(user.errors).to have_key(:name)
    end

    it 'should be false when email is not valid' do
      user = described_class.new(name: 'John Doe', email: 'john',
                                 crypted_password: 'a_secure_passWord!')
      expect(user.valid?).to eq false
      expect(user.errors).to have_key(:email)
    end

    it 'should be false when password is blank' do
      user = described_class.new(name: 'John Doe', email: 'john')
      expect(user.valid?).to eq false
      expect(user.errors).to have_key(:crypted_password)
    end

    it 'should be true when all field are valid' do
      user = described_class.new(name: 'John Doe', email: 'john@doe.com',
                                 crypted_password: 'a_secure_passWord!')
      expect(user.valid?).to eq true
    end
  end

  describe 'has password?' do
    let(:password) { 'password' }
    let(:user) do
      described_class.new(password: password,
                          email: 'john.doe@someplace.com',
                          name: 'john doe')
    end

    it 'should return false when password do not match' do
      expect(user).not_to have_password('invalid')
    end

    it 'should return true when password do  match' do
      expect(user).to have_password(password)
    end
  end

  describe 'subscription' do
    let(:on_demand_user) do
      described_class.new(name: 'john doe',
                          subscription: OnDemandSubscription.new)
    end
    let(:professional_user) do
      described_class.new(name: 'john doe',
                          subscription: ProfessionalSubscription.new)
    end

    let(:corporate_user) do
      described_class.new(name: 'john doe',
                          subscription: CorporateSubscription.new)
    end

    it 'with 4 active offers and on-demand subscription the amount to pay is 40' do
      offer_counter = instance_double('offer_counter', count_by_user: 4)
      expect(on_demand_user.calculate_subscription_billing(offer_counter)).to eq 40
    end

    it 'with 8 active offers and proffesional subscription the amount to pay is 51' do
      offer_counter = instance_double('offer_counter', count_by_user: 8)
      expect(professional_user.calculate_subscription_billing(offer_counter)).to eq 51
    end

    it 'with 20 active offers and corporate subscription the amount to pay is 80' do
      offer_counter = instance_double('offer_counter', count_by_user: 20)
      expect(corporate_user.calculate_subscription_billing(offer_counter)).to eq 80
    end
  end
end
