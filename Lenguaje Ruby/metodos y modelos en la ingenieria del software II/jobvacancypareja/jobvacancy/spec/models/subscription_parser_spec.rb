require 'spec_helper'

describe SubscriptionParser do
  let(:subscription_parser) { described_class.new }

  it 'parse subscription on-demand returns the class OnDemandSubscription' do
    expect(subscription_parser.parse('on-demand').is_a?(OnDemandSubscription)).to eq true
  end

  it 'parse subscription professional returns the class ProfessionalSubscription' do
    expect(subscription_parser.parse('professional').is_a?(ProfessionalSubscription)).to eq true
  end

  it 'parse subscription corporate returns the class CorporateSubscription' do
    expect(subscription_parser.parse('corporate').is_a?(CorporateSubscription)).to eq true
  end

  it 'parse subscription corporative returns the class CorporateSubscription' do
    expect(subscription_parser.parse('corporative').is_a?(CorporateSubscription)).to eq true
  end

  it 'parse invalid subscription returns InvalidSubscriptionError' do
    expect { subscription_parser.parse('premium') }.to raise_error(InvalidSubscriptionError)
  end
end
