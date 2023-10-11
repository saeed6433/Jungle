class SessionsController < ApplicationController
  # before_action :authorize

  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      log_in(user) # A custom method to log in the user
      redirect_to root_path
    else
      flash[:alert] = 'Invalid email or password'
      redirect_to login_path
    end
  end

  def destroy
    log_out # A custom method to log out the user
    redirect_to login_path
  end

  private

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
  end
end
