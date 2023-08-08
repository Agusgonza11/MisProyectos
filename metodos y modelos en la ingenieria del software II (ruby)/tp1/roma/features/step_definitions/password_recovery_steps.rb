VALID_PASSWORD = 'ABCabc1234'.freeze

And(/^I have an account$/) do
  @user = User.new(email: 'password_recovery@test.com',
                   name: 'Recovery',
                   password: 'Passw0rd!')
  UserRepository.new.save(@user)
end

When(/^I click recover password$/) do
  click_link('Recover Password')
end

And(/^I enter my email address$/) do
  fill_in('email', with: @user.email)
  click_button('Recover Password')
end

Then(/^I should get an email with a recovery code$/) do
  mail_store = "#{Padrino.root}/tmp/emails"
  file = File.open("#{mail_store}/#{@user.email}", 'r')
  content = file.read
  @code = nil
  content.each_line do |line|
    if line.include? 'Code:'
      @code = line[7, 8]
      break
    end
  end
  expect(@code.nil?).to eq false
end

Given(/^I have a valid recovery code$/) do
  click_button('Recover Password')
  fill_in('email', with: @user.email)
  click_button('Recover Password')
  mail_store = "#{Padrino.root}/tmp/emails"
  file = File.open("#{mail_store}/#{@user.email}", 'r')
  content = file.read
  @code = nil
  content.each_line do |line|
    if line.include? 'Code:'
      @code = line[7, 8]
      break
    end
  end
  expect(@code.nil?).to eq false
end

And(/^I am at the recovery page$/) do
  visit '/code'
end

When(/^I enter the recovery code and email$/) do
  fill_in('email', with: @user.email)
  fill_in('reset_code', with: @code)
  click_button('Confirm')
end

And(/^I enter a new valid password$/) do
  fill_in('password', with: VALID_PASSWORD)
end

Then(/^I should be able to login$/) do
  visit '/login'
  fill_in('user[email]', with: @user.email)
  fill_in('user[password]', with: VALID_PASSWORD)
  click_button('Login')
  page.should have_content(@user.email)
end

When(/^I click recover password with an inexistent mail$/) do
  click_button('Recover Password')
  fill_in('email', with: '')
  click_button('Recover Password')
end

Then(/^I should see a {string} message$/) do |msg|
  page.should have_content(msg)
end
