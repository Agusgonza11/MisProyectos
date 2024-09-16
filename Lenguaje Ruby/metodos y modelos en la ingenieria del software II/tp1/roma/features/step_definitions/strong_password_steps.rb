When('I register with {string} as the password') do |password|
  visit '/register'
  fill_in('user[name]', with: 'valid_password@test.com')
  fill_in('user[email]', with: 'valid_password@test.com')
  fill_in('user[password]', with: password)
  fill_in('user[password_confirmation]', with: password)
  click_button('Create')
end

Then('I should see the message {string}') do |message|
  page.should have_content(message)
end
