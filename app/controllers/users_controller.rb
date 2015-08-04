class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    # Don't show information about a user that shares no trips with current user
    if current_user.shares_trip_with?(@user) == false
      redirect_to root_path, alert: "You are not authorized to view this user's information."
    end
  end
end