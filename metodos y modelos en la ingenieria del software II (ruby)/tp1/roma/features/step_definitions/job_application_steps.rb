Given(/^only a "(.*?)" offer exists in the offers list$/) do |job_title|
  @job_offer = JobOffer.new(title: job_title, location: 'a nice job', description: 'a nice job')
  @job_offer.owner = UserRepository.new.find_by_email('offerer@test.com')
  @job_offer.is_active = true
  JobOfferRepository.new.delete_all
  JobOfferRepository.new.save @job_offer
end

Given(/^I access the offers list page$/) do
  visit '/job_offers'
end

When(/^I apply$/) do
  click_button('Apply')
end

Then(/^I should receive a mail with offerer info$/) do
  mail_store = "#{Padrino.root}/tmp/emails"
  file = File.open("#{mail_store}/offerer@test.com", 'r')
  content = file.read
  content.include?(@job_offer.title).should be true
  content.include?(@job_offer.location).should be true
  content.include?(@job_offer.description).should be true
  content.include?(@job_offer.owner.email).should be true
  content.include?(@job_offer.owner.name).should be true
end
