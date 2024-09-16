APPLICATION_SUCCESSFUL_MESSAGE = 'Contact information sent.'.freeze
LOGIN_REQUIRED_MESSAGE = 'You need to be logged in to apply to an offer!'.freeze

Given('I am logged in') do
  visit '/login'
  fill_in('user[email]', with: 'offerer@test.com')
  fill_in('user[password]', with: 'Passw0rd!')
  click_button('Login')
  page.should have_content('offerer@test.com')
end

Then('I should see a application successful message') do
  page.should have_content(APPLICATION_SUCCESSFUL_MESSAGE)
end

Then('I should see a login required error message') do
  page.should have_content(LOGIN_REQUIRED_MESSAGE)
end
