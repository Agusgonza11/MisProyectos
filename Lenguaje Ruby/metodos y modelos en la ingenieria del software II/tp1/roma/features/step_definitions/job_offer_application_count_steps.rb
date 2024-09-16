USER_OFFERER = { 'mail' => 'offerer@test.com', 'password' => 'Passw0rd!' }.freeze
USER_APPLICANT = { 'mail' => 'applicant@test.com', 'password' => 'Passw0rd!' }.freeze

def login_with(user)
  begin
    visit '/logout'
  rescue StandardError
    # Ignored
  end
  visit '/login'

  fill_in('user[email]', with: user['mail'])
  fill_in('user[password]', with: user['password'])
  click_button('Login')
end

def apply(user)
  login_with(user)
  visit '/job_offers'
  click_button('Apply')
end

Then('I should see {int} as the number of applicants') do |count|
  login_with(USER_OFFERER)
  visit '/job_offers/my'
  page.should have_content("#{count} applicants")
end

When(/^a user applies to "([^"]*)" offer$/) do |_string|
  apply(USER_OFFERER)
end

When(/^no users apply to "([^"]*)" offer$/) do |_arg|
end

When(/^another user applies to "([^"]*)" offer$/) do |_arg|
  apply(USER_APPLICANT)
end

When(/^the same user applies to "([^"]*)" offer$/) do |_arg|
  apply(USER_OFFERER)
end

And(/^it is active$/) do
  visit '/job_offers/my'
end
