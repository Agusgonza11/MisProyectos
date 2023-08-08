class ErrorsPresenter
  MESSAGES = {
    'too short': 'Password should be at least 10 characters long',
    'missing number': 'Password should have at least 1 number',
    'missing uppercase': 'Password should have at least 1 uppercase character',
    'missing lowercase': 'Password should have at least 1 lowercase character'
  }.freeze

  def display_errors_to_messages(code)
    MESSAGES[code.to_sym]
  end
end
