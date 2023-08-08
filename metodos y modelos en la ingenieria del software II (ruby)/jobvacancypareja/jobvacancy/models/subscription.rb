class Subscription
  attr_accessor :subscription_cost

  def initialize(cost)
    @subscription_cost = cost
  end
end

class OnDemandSubscription < Subscription
  ON_DEMAND_SUBSCRIPTION_COST = 10

  def initialize
    super(ON_DEMAND_SUBSCRIPTION_COST)
  end

  def calculate_amount(offers_count)
    offers_count * @subscription_cost
  end
end

class ProfessionalSubscription < Subscription
  PROFESSIONAL_SUBSCRIPTION_COST = 30
  LIMIT_OFFERS_QUANTITY = 5
  ADITIONAL_OFFER_COST = 7
  NO_ADITIONAL_OFFER = 0

  def initialize
    super(PROFESSIONAL_SUBSCRIPTION_COST)
  end

  def calculate_amount(offers_count)
    @subscription_cost + calculate_additional_cost(offers_count)
  end

  protected

  def calculate_additional_cost(offers_count)
    return (offers_count - LIMIT_OFFERS_QUANTITY) * ADITIONAL_OFFER_COST if offers_count > LIMIT_OFFERS_QUANTITY

    NO_ADITIONAL_OFFER
  end
end

class CorporateSubscription < Subscription
  CORPORATE_SUBSCRIPTION_COST = 80

  def initialize
    super(CORPORATE_SUBSCRIPTION_COST)
  end

  def calculate_amount(_offers_count)
    @subscription_cost
  end
end

class SubscriptionParser
  def initialize
    @valid_subscriptions = %w[on-demand professional corporate corporative]
  end

  def parse(subscription_type)
    raise InvalidSubscriptionError unless @valid_subscriptions.include?(subscription_type) || subscription_type.nil?

    # Aca agregamos la condicion de subscripcion nula porque no pudimos setear el valor default en la semilla del db
    case subscription_type
    when 'on-demand'
      OnDemandSubscription.new
    when 'professional'
      ProfessionalSubscription.new
    when 'corporate', 'corporative'
      CorporateSubscription.new
    else
      OnDemandSubscription.new
    end
  end

  def to_s(subscription_type)
    case subscription_type
    when OnDemandSubscription
      'on-demand'
    when ProfessionalSubscription
      'professional'
    when CorporateSubscription
      'corporate'
    end
  end
end

class InvalidSubscriptionError < StandardError
  def initialize(msg = 'Unknown subscription received')
    super
  end
end
