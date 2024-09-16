class ReportGenerator
  def initialize(counter, calculator, current_users, parser)
    @offer_counter = counter
    @billing_calculator = calculator
    @users = current_users
    @parser = parser
    @report_items = []
  end

  def generate_report
    @users.each do |user|
      @report_items.append(generate_user_billing_info(user))
    end
    { 'items': @report_items,
      'total_amount': @billing_calculator.inform_total_billing,
      'total_active_offers': @offer_counter.count_active }
  end

  protected

  def generate_user_billing_info(user)
    user_amount_to_pay = user.calculate_subscription_billing(@offer_counter)
    @billing_calculator.register(user_amount_to_pay)
    user_active_offers = @offer_counter.count_by_user(user)
    { 'user_email': user.email,
      'subscription': @parser.to_s(user.subscription),
      'active_offers_count': user_active_offers,
      'amount_to_pay': user_amount_to_pay }
  end
end
