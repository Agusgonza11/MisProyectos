require 'spec_helper'

describe OfferCounter do
  describe 'count_active' do
    it 'should be 0 when no active offers' do
      repo = instance_double('offer_repo', all_active: [])
      counter = described_class.new(repo)
      expect(counter.count_active).to eq 0
    end
  end

  describe 'count_by_user' do
    let(:user) do
      User.new(name: 'john doe',
               subscription: OnDemandSubscription.new)
    end
    let(:active_offer) { JobOffer.new(title: 'active', is_active: true) }
    let(:inactive_offer) { JobOffer.new(title: 'inactive', is_active: false) }

    it 'should be 2 when the user has 2 active offers' do
      repo = instance_double('offer_repo', find_by_owner: [active_offer, active_offer])
      counter = described_class.new(repo)
      expect(counter.count_by_user(user)).to eq 2
    end

    it 'should be 1 when the user has 1 active offers and 1 inactive offer' do
      repo = instance_double('offer_repo', find_by_owner: [active_offer, inactive_offer])
      counter = described_class.new(repo)
      expect(counter.count_by_user(user)).to eq 1
    end
  end
end
