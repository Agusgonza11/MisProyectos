require 'json'
# Notamos que muchos de los pasos podrian llegar a reducirse y unificarse, pero no sabiamos si era
# el objetivo del ejercicio que sean modificados por eso los dejamos en la misma forma que los recibimos
Given('user {string} with an on-demand susbcription') do |user_email|
  UserRepository.new.delete_all
  @user = User.create(user_email, user_email, 'somePassword!', OnDemandSubscription.new)
  UserRepository.new.save(@user)
end

Given('there are no offers at all') do
  JobOfferRepository.new.delete_all
end

When('I get the billing report') do
  visit 'reports/billing'
  @report_as_json = JSON.parse(page.body)
end

Then('the total active offers is {int}') do |expected_active_offers|
  expect(@report_as_json['total_active_offers']).to eq expected_active_offers
end

Then('the total amount is {float}') do |expected_total_amount|
  expect(@report_as_json['total_amount']).to eq expected_total_amount
end

Given('a user {string} with {string} subscription') do |user_email, subscription_type|
  UserRepository.new.delete_all
  @user = User.create(user_email, user_email, 'somePassword!', SubscriptionParser.new.parse(subscription_type))
  UserRepository.new.save(@user)
end

Given('{int} active offers') do |offer_count|
  offer_count.times do
    @job_offer = JobOffer.new(title: 'a title', location: 'a nice job', description: 'a nice job')
    @job_offer.owner = @user
    @job_offer.activate
    JobOfferRepository.new.save(@job_offer)
  end
end

Then('the amount to pay for the user {string} is {float}') do |user_email, expected_amount|
  reported_user = @report_as_json['items'].select { |user| user['user_email'] == user_email }.first
  expect(reported_user['amount_to_pay']).to eq expected_amount
end

Then('the total active offers are {int}') do |expected_offer_count|
  expect(@report_as_json['total_active_offers']).to eq expected_offer_count
end

Given('another user {string} with {string} susbcription') do |user_email, subscription_type|
  @user = User.create(user_email, user_email, 'somePassword!', SubscriptionParser.new.parse(subscription_type))
  UserRepository.new.save(@user)
end

Given('the user {string} has {int} active offers') do |user_email, active_offer_count|
  UserRepository.new.delete_all
  @user = User.create(user_email, user_email, 'somePassword!', OnDemandSubscription.new)
  UserRepository.new.save(@user)
  active_offer_count.times do
    @job_offer = JobOffer.new(title: 'a title', location: 'a nice job', description: 'a nice job')
    @job_offer.owner = @user
    @job_offer.activate
    JobOfferRepository.new.save(@job_offer)
  end
end

Given('{int} inactive offers') do |inactive_offer_count|
  inactive_offer_count.times do
    @job_offer = JobOffer.new(title: 'a title', location: 'a nice job', description: 'a nice job')
    @job_offer.owner = @user
    @job_offer.deactivate
    JobOfferRepository.new.save(@job_offer)
  end
end

Then('the billing for this user is {float}') do |expected_amount|
  reported_user = @report_as_json['items'].select { |user| user['user_email'] == @user.email }.first
  expect(reported_user['amount_to_pay']).to eq expected_amount
end

Given('the user {string}') do |user_email|
  UserRepository.new.delete_all
  @user = User.create(user_email, user_email, 'somePassword!', OnDemandSubscription.new)
  UserRepository.new.save(@user)
end

Given('another user with {string} susbcription') do |subscription|
  @user = User.create('other@user.com', 'other@user.com', 'somePassword!', SubscriptionParser.new.parse(subscription))
  UserRepository.new.save(@user)
end

Then('the amount to pay for the user {string} is {float}.') do |user_email, expected_amount|
  reported_user = @report_as_json['items'].select { |user| user['user_email'] == user_email }.first
  expect(reported_user['amount_to_pay']).to eq expected_amount
end
