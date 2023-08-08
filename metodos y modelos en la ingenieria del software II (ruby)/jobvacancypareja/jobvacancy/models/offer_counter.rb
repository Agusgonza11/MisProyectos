class OfferCounter
  def initialize(offer_repo)
    @repo = offer_repo
  end

  def count_by_user(user)
    user_offers = @repo.find_by_owner(user)
    user_offers.select(&:is_active?).size
  end

  def count_active
    @repo.all_active.size
  end
end
