class UsersController < ApplicationController

  def index
    if session[:user_id].nil?
      redirect_to login_path
    else
      @user = User.find(session[:user_id])
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    redirect_to root_path, notice: "Success! Created user #{@user.name}."
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
