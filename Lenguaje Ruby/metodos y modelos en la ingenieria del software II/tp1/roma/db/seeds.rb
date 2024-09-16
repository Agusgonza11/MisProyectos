require_relative '../models/user'

user_repository = UserRepository.new
unless user_repository.all.count == 2
  user = User.new(email: 'offerer@test.com',
                  name: 'Offerer',
                  password: 'Passw0rd!')

  user_repository.save user
  applicant = User.new(email: 'applicant@test.com',
                       name: 'Applicant',
                       password: 'Passw0rd!')

  user_repository.save applicant
end
