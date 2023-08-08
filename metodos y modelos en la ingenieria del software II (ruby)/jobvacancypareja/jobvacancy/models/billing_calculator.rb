class BillingCalculator
  INITIAL_BILLING = 0

  def initialize
    @current_billing = INITIAL_BILLING
  end

  def register(amount_to_register)
    @current_billing += amount_to_register
  end

  def inform_total_billing
    @current_billing
  end
end
