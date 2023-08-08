BLOCKED_USER_MESSAGE = 'Account locked due to too many failed login attempts'.freeze

Given('I am at the login page') do
  visit '/login'
end

When('I try to login {int} times with wrong credentials') do |login_try|
  UserRepository.new.delete_all
  user = User.new(email: 'offertester@test.com',
                  name: 'Offerer',
                  password: 'ABCDefdh123')
  UserRepository.new.save(user)
  login_try.times do
    fill_in('user[email]', with: 'offertester@test.com')
    fill_in('user[password]', with: 'wrongPassword')
    click_button('Login')
  end
end

Then('I should see an account blocked message') do
  page.should have_content(BLOCKED_USER_MESSAGE)
end

Given('my account is blocked') do
  UserRepository.new.delete_all
  user = User.new(email: 'offertester@test.com',
                  name: 'Offerer',
                  password: 'ABCDefdh123')
  user.login_manager.failed_attempts = 3
  UserRepository.new.save(user)
end

When('I try to login') do
  fill_in('user[email]', with: 'offertester@test.com')
  fill_in('user[password]', with: 'wrongPassword')
  click_button('Login')
end
