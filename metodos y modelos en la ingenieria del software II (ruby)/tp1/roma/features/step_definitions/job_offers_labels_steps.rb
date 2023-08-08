When('I create a new offer with {string} as label') do |labels|
  visit '/job_offers/new'
  fill_in('job_offer_form[title]', with: 'A job offer')
  fill_in('job_offer_form[labels]', with: labels)
  click_button('Create')
end

Then('I should see {string} as label in my offers list') do |labels|
  visit '/job_offers/my'
  page.should have_content(labels)
end

Given('a offer with {string} as label') do |labels|
  JobOfferRepository.new.delete_all

  visit '/job_offers/new'
  fill_in('job_offer_form[title]', with: 'A job offer')
  fill_in('job_offer_form[labels]', with: labels)
  click_button('Create')
end

When('I update the label with {string}') do |labels|
  click_link('Edit')
  fill_in('job_offer_form[title]', with: 'A job offer')
  fill_in('job_offer_form[labels]', with: labels)
  click_button('Save')
end
