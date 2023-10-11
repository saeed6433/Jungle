class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user) # A custom method to log in the user
      redirect_to root_path
    else
      flash[:alert] = 'Registration failed. Please check your information.'
      redirect_to signup_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

  def log_in(user)
    session[:user_id] = user.id
  end
end
