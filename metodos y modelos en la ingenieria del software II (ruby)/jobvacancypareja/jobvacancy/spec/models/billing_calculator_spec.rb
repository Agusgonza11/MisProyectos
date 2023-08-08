require 'spec_helper'

describe BillingCalculator do
  describe 'total billing' do
    let(:billing_calculator) { described_class.new }
    let(:on_demand_user) do
      User.new(name: 'on demand user',
               subscription: OnDemandSubscription.new)
    end
    let(:professional_user) do
      User.new(name: 'professional user',
               subscription: ProfessionalSubscription.new)
    end
    let(:corporate_user) do
      User.new(name: 'corporate user',
               subscription: CorporateSubscription.new)
    end

    it 'should be 150 when there is a corporate user with no offers and an on-demand user with 7 active offers' do
      counter_corporate = instance_double('offer_counter', count_by_user: 0)
      billing_calculator.register(corporate_user.calculate_subscription_billing(counter_corporate))
      counter_on_demand = instance_double('offer_counter', count_by_user: 7)
      billing_calculator.register(on_demand_user.calculate_subscription_billing(counter_on_demand))
      expect(billing_calculator.inform_total_billing).to eq 150
    end

    it 'should be 60 when there are two professional users with 3 offers each' do
      counter = instance_double('offer_counter', count_by_user: 3)
      billing_calculator.register(professional_user.calculate_subscription_billing(counter))
      billing_calculator.register(professional_user.calculate_subscription_billing(counter))
      expect(billing_calculator.inform_total_billing).to eq 60
    end
  end
end
