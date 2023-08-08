require_relative '../views/users/errors_presenter'

JobVacancy::App.controllers :users do
  get :new, map: '/register' do
    @user = User.new
    render 'users/new'
  end

  get :my do
    @user = UserRepository.new.find_by_email(current_user.email)
    render 'users/my_profile'
  end

  get :edit, with: :user_id do
    @user = UserRepository.new.find_by_email(current_user.email)
    render 'users/edit'
  end

  post :create do
    password_confirmation = params[:user][:password_confirmation]
    params[:user].reject! { |k, _| k == 'password_confirmation' }

    @user = User.new(params[:user])

    password = params[:user][:password]
    validation_result = PasswordValidator.new.validate_password(password)
    if validation_result.is_valid?
      if password == password_confirmation
        if UserRepository.new.save(@user)
          flash[:success] = 'User created'
          redirect '/'
        else
          flash.now[:error] = 'All fields are mandatory'
          render 'users/new'
        end
      else
        flash.now[:error] = 'Passwords do not match'
        render 'users/new'
      end
    else
      error_presenter = ErrorsPresenter.new
      flash.now[:error] = validation_result.errors.map do |error|
        error_presenter.display_errors_to_messages(error)
      end.join('<br>').html_safe
      render 'users/new'
    end
  end

  post :update, with: :user_id do
    puts params[:user]
    puts params[:user_id]
    @user = UserRepository.new.find_by_id(params[:user_id])
    @user.preferences = format_preferences(params[:user][:preferences])

    if UserRepository.new.save(@user)
      flash[:success] = 'Preferences updated'
      redirect '/users/my'
    end
  end
end
