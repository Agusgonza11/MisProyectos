PREFERENCES_UPDATED_MESSAGE = 'Preferences updated'.freeze

Given('I am in my profile page') do
  visit '/users/my'
end

When('I change my preferences to {string}') do |preferences|
  click_link('Edit preferences')
  fill_in('user[preferences]', with: preferences)
  click_button('Save')
end

Then('I should see a preferences updated message') do
  page.should have_content(PREFERENCES_UPDATED_MESSAGE)
end

Then('I should see {string} as my preferences') do |preferences|
  page.should have_content(preferences)
end

Given('I set my preferences to {string}') do |_string|
  pending # Write code here that turns the phrase above into concrete actions
end

When('an offer {string} with labels {string} is activated') do |_string, _string2|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should receive a notification mail with {string}') do |_string|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should not receive a notification mail with {string}') do |_string|
  pending # Write code here that turns the phrase above into concrete actions
end
