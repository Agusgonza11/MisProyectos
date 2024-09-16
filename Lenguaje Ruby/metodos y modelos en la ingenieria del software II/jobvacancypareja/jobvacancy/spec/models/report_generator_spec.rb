require 'spec_helper'

describe ReportGenerator do
  describe 'user_report' do
    let(:billing_calculator) { BillingCalculator.new }
    let(:parser) { SubscriptionParser.new }
    let(:users) { [user] }
    let(:user) do
      User.new(name: 'on demand user',
               subscription: OnDemandSubscription.new)
    end

    it 'on-demand user with 2 active offers the amount should be 20 and the active count should be 2' do
      offer_counter = instance_double('offer_counter', count_by_user: 2, count_active: 2)
      report_generator = described_class.new(offer_counter, billing_calculator, users, parser)
      report_data = report_generator.generate_report
      expect(report_data[:total_amount]).to eq 20
      expect(report_data[:total_active_offers]).to eq 2
    end
  end
end
