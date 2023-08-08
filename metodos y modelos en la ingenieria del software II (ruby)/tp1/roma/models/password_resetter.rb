require 'securerandom'

class PasswordResetter
  attr_accessor :user_email, :recovery_code

  CODE_LENGTH = 8

  def initialize(email)
    @user_email = email
    @recovery_code = SecureRandom.alphanumeric(CODE_LENGTH).upcase
  end

  def process
    JobVacancy::App.deliver(:notification, :recovery_code_email, self)
  end
end
