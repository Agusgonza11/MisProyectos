class UserRepository < BaseRepository
  self.table_name = :users
  self.model_class = 'User'

  def find_by_email(email)
    row = dataset.first(email: email)
    load_object(row) unless row.nil?
  end

  def find_by_id(id)
    row = dataset.first(id: id)
    load_object(row) unless row.nil?
  end

  protected

  def changeset(user)
    {
      name: user.name,
      crypted_password: user.crypted_password,
      email: user.email,
      failed_attempts: user.login_manager.failed_attempts,
      preferences: user.preferences
    }
  end

  def load_object(a_record)
    user = Object.const_get(self.class.model_class).new(a_record)
    login_manager = LoginManager.new
    login_manager.failed_attempts = a_record[:failed_attempts]
    user.login_manager = login_manager
    user
  end
end
