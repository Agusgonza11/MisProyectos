JobVacancy::App.controllers :sessions do
  get :login, map: '/login' do
    @user = User.new
    render 'sessions/new'
  end

  post :create do
    email = params[:user][:email]
    password = params[:user][:password]

    gate_keeper = GateKeeper.new.authenticate(email, password)

    gate_keeper.when_succeed do |user|
      @user = user
      if @user.is_blocked?
        flash[:error] = 'Account locked due to too many failed login attempts'
        redirect '/login'
      end
      sign_in @user
      redirect '/'
    end

    gate_keeper.when_failed do |is_blocked|
      flash[:error] = 'Invalid credentials'
      flash[:error] = 'Account locked due to too many failed login attempts' if is_blocked
      redirect '/login'
    end
  end

  get :destroy, map: '/logout' do
    sign_out
    redirect '/'
  end

  get :reset, map: '/reset' do
    @user = User.new
    render 'sessions/recover_password'
  end

  post :reset do
  end
end
