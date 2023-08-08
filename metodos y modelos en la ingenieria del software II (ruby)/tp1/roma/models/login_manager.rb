class LoginManager
  attr_accessor :failed_attempts

  def initialize
    @failed_attempts = 0
  end

  def compare_passwords(comparison_result)
    if comparison_result && !is_blocked?
      @failed_attempts = 0
    else
      @failed_attempts += 1
    end
  end

  def is_blocked?
    @failed_attempts >= 3
  end
end
