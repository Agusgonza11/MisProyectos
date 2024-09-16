require 'spec_helper'

describe ProfessionalSubscription do
  let(:professional_subscription) { described_class.new }

  it 'with 0 offers the amount to pay is 30' do
    expect(professional_subscription.calculate_amount(0)).to eq 30
  end

  it 'with 1 offers the amount to pay is 30' do
    expect(professional_subscription.calculate_amount(1)).to eq 30
  end

  it 'with 5 offers the amount to pay is 30' do
    expect(professional_subscription.calculate_amount(5)).to eq 30
  end

  it 'with 6 offers the amount to pay is 37' do
    expect(professional_subscription.calculate_amount(6)).to eq 37
  end
end
