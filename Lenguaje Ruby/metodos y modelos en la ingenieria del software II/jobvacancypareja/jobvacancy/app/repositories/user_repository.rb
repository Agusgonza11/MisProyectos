require_relative '../../models/subscription'

class UserRepository < BaseRepository
  self.table_name = :users
  self.model_class = 'User'

  def find_by_email(email)
    row = dataset.first(email: email)
    load_object(row) unless row.nil?
  end

  def current_users
    load_collection(dataset)
  end

  protected

  def load_object(a_record)
    user = User.new(a_record)
    user.subscription = SubscriptionParser.new.parse(user.subscription)
    user
  end

  def changeset(user)
    {
      name: user.name,
      crypted_password: user.crypted_password,
      email: user.email,
      subscription: SubscriptionParser.new.to_s(user.subscription)
    }
  end
end
