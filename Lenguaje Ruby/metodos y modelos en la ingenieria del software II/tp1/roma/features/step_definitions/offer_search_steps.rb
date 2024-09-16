Given('there is an offer with {string} as the title') do |a_title|
  JobOfferRepository.new.delete_all
  @title = a_title
end

And('there is another offer with {string} as the title') do |a_title|
  @title = a_title
end

And('{string} as the location') do |a_location|
  @location = a_location
end

And('{string} as the description') do |a_description|
  @description = a_description
end

And('{string} as labels') do |some_labels|
  @job_offer = JobOffer.new(title: @title, location: @location, description: @description, labels: some_labels)
  @job_offer.owner = UserRepository.new.first
  @job_offer.is_active = true

  JobOfferRepository.new.save @job_offer
end

When('I search an offer with {string}') do |text_to_search|
  visit '/job_offers/latest'
  fill_in('q', with: text_to_search)
  click_button('search')
end

Then('I should see the offer {string}') do |text_searched|
  page.should have_content(text_searched)
end
