class PasswordValidator
  MIN_CHARACTERS_LENGHT = 10
  NUMBER_REGEX = /\d/.freeze
  UPPERCASE_REGEX = /[A-Z]/.freeze
  LOWERCASE_REGEX = /[a-z]/.freeze
  ERROR_PASSWORD_TOO_SHORT = 'too short'.freeze
  ERROR_PASSWORD_WITHOUT_NUMBER = 'missing number'.freeze
  ERROR_PASSWORD_WITHOUT_UPPERCASE = 'missing uppercase'.freeze
  ERROR_PASSWORD_WITHOUT_LOWERCASE = 'missing lowercase'.freeze

  def initialize
    @validation_result = ValidationResult.new
  end

  def validate_password(password)
    @validation_result.add_validation(validate_length(password))
    @validation_result.add_validation(validate_number(password))
    @validation_result.add_validation(validate_uppercase(password))
    @validation_result.add_validation(validate_lowercase(password))
    @validation_result
  end

  protected

  def validate_length(password)
    return ERROR_PASSWORD_TOO_SHORT if password.length < MIN_CHARACTERS_LENGHT
  end

  def validate_number(password)
    return ERROR_PASSWORD_WITHOUT_NUMBER unless password =~ NUMBER_REGEX
  end

  def validate_uppercase(password)
    return ERROR_PASSWORD_WITHOUT_UPPERCASE unless password =~ UPPERCASE_REGEX
  end

  def validate_lowercase(password)
    return ERROR_PASSWORD_WITHOUT_LOWERCASE unless password =~ LOWERCASE_REGEX
  end
end

class ValidationResult
  def initialize
    @errors = []
  end

  def is_valid?
    @errors.empty?
  end

  def add_validation(error_message)
    @errors.append(error_message) unless error_message.nil?
  end

  attr_reader :errors
end
