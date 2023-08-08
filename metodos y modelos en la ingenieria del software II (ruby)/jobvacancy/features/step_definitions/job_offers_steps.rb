OFFER_CREATED_MESSAGE = 'Offer created'.freeze
OFFER_UPDATED_MESSAGE = 'Offer updated'.freeze
OFFER_DELETED_MESSAGE = 'Offer deleted'.freeze
REQUIRED_EXPERIENCE_ERROR_NEGATIVE = 'must be greater than or equal to 0'.freeze
REQUIRED_EXPERIENCE_ERROR_INTEGER = 'must be an integer'.freeze
REGISTRATION_MENU = 'register'.freeze
JOB_OFFERS_MENU = 'Job offers'.freeze

When(/^I browse the default page$/) do
  visit '/'
end

Given(/^I am logged in as job offerer$/) do
  visit '/login'
  fill_in('user[email]', with: 'offerer@test.com')
  fill_in('user[password]', with: 'Passw0rd!')
  click_button('Login')
  page.should have_content('offerer@test.com')
end

When(/^I create a new offer with "(.*?)" as the title$/) do |title|
  visit '/job_offers/new'
  fill_in('job_offer_form[title]', with: title)
  click_button('Create')
end

Then(/^I should see a offer created confirmation message$/) do
  page.should have_content(OFFER_CREATED_MESSAGE)
end

Then(/^I should see a offer updated confirmation message$/) do
  page.should have_content(OFFER_UPDATED_MESSAGE)
end

Then(/^I should see a offer deleted confirmation message$/) do
  page.should have_content(OFFER_DELETED_MESSAGE)
end

Then(/^I should see "(.*?)" in my offers list$/) do |content|
  visit '/job_offers/my'
  page.should have_content(content)
end

Then(/^I should not see "(.*?)" in my offers list$/) do |content|
  visit '/job_offers/my'
  page.should_not have_content(content)
end

Then(/^I should see a registration menu$/) do
  page.should have_content(REGISTRATION_MENU)
end

Then(/^I should see a job offers menu$/) do
  page.should have_content(JOB_OFFERS_MENU)
end

Given(/^I have "(.*?)" offer in my offers list$/) do |offer_title|
  JobOfferRepository.new.delete_all

  visit '/job_offers/new'
  fill_in('job_offer_form[title]', with: offer_title)
  click_button('Create')
end

When(/^I change the title to "(.*?)"$/) do |new_title|
  click_link('Edit')
  fill_in('job_offer_form[title]', with: new_title)
  click_button('Save')
end

And(/^I delete it$/) do
  click_button('Delete')
end

When('I create a new offer with {string} as the title and {int} as the required experience') do |title, experience|
  visit '/job_offers/new'
  fill_in('job_offer_form[title]', with: title)
  fill_in('job_offer_form[required_experience]', with: experience)
  click_button('Create')
end

When('I create a new offer with {string} as the title and {float} as the experience required') do |title, experience|
  visit '/job_offers/new'
  fill_in('job_offer_form[title]', with: title)
  fill_in('job_offer_form[required_experience]', with: experience)
  click_button('Create')
end

Then('I should see a invalid required experience message, must be positive') do
  page.should have_content(REQUIRED_EXPERIENCE_ERROR_NEGATIVE)
end

Then('I should see a invalid required experience message, must be an integer') do
  page.should have_content(REQUIRED_EXPERIENCE_ERROR_INTEGER)
end

Then('I should see {string} in experience required field') do |value|
  page.should have_content(value)
end
