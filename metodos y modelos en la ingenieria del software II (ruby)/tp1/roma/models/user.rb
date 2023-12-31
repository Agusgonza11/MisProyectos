require_relative 'login_manager'

class User
  include ActiveModel::Validations

  attr_accessor :id, :name, :email, :crypted_password, :job_offers, :updated_on, :created_on, :login_manager,
                :preferences

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze

  validates :name, :crypted_password, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX,
                                              message: 'invalid email' }

  def initialize(data = {})
    @id = data[:id]
    @name = data[:name]
    @email = data[:email]
    @crypted_password = if data[:password].nil?
                          data[:crypted_password]
                        else
                          Crypto.encrypt(data[:password])
                        end
    @job_offers = data[:job_offers]
    @updated_on = data[:updated_on]
    @created_on = data[:created_on]
    @login_manager = LoginManager.new
    @preferences = data[:preferences]
  end

  def has_password?(password)
    comparison = Crypto.decrypt(crypted_password) == password
    @login_manager.compare_passwords(comparison)
    comparison
  end

  def is_blocked?
    @login_manager.is_blocked?
  end
end
