require 'spec_helper'

describe OnDemandSubscription do
  let(:on_demand_subscription) { described_class.new }

  it 'with 0 offers the amount to pay is 0' do
    expect(on_demand_subscription.calculate_amount(0)).to eq 0
  end

  it 'with 1 offer the amount to pay is 10' do
    expect(on_demand_subscription.calculate_amount(1)).to eq 10
  end

  it 'with 5 offer the amount to pay is 50' do
    expect(on_demand_subscription.calculate_amount(5)).to eq 50
  end
end
