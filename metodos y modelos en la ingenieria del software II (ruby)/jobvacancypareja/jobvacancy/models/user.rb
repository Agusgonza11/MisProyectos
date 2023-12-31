class User
  include ActiveModel::Validations

  attr_accessor :id, :name, :email, :crypted_password, :job_offers, :updated_on, :created_on, :subscription

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze

  validates :name, :crypted_password, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX,
                                              message: 'invalid email' }

  def self.create(name, email, password, subscription)
    data = {}
    data[:name] = name
    data[:email] = email
    data[:password] = password
    data[:subscription] = subscription
    User.new(data)
  end

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
    @subscription = data[:subscription]
  end

  def has_password?(password)
    Crypto.decrypt(crypted_password) == password
  end

  def calculate_subscription_billing(offer_counter)
    @subscription.calculate_amount(offer_counter.count_by_user(self))
  end
end
