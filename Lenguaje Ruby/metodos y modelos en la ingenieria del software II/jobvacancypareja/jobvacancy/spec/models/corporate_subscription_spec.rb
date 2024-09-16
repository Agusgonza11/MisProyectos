require 'spec_helper'

describe CorporateSubscription do
  let(:corporate_subscription) { described_class.new }

  it 'with 0 offers the amount to pay is 80' do
    expect(corporate_subscription.calculate_amount(0)).to eq 80
  end

  it 'with 5 offers the amount to pay is 80' do
    expect(corporate_subscription.calculate_amount(5)).to eq 80
  end

  it 'with 100 offers the amount to pay is 80' do
    expect(corporate_subscription.calculate_amount(100)).to eq 80
  end
end
