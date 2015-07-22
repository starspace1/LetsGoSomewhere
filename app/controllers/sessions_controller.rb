class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Success! Logged in as #{user.name}"
    else
      session[:user_id] = nil
      redirect_to login_path, notice: "Incorrect email/password combination. Please try again."
    end

  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Logged out."
  end
end
