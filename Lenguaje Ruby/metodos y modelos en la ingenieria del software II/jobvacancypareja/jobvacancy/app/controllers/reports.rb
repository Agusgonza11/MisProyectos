JobVacancy::App.controllers :reports, provides: [:json] do
  get :billing do
    offer_repository = JobOfferRepository.new
    offer_counter = OfferCounter.new(offer_repository)
    billing_calculator = BillingCalculator.new
    users = UserRepository.new.current_users
    parser = SubscriptionParser.new
    report_generator = ReportGenerator.new(offer_counter, billing_calculator, users, parser)
    return report_generator.generate_report.to_json
  end
end
