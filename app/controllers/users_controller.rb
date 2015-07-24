class UsersController < ApplicationController
  def edit_destinations
    @user = current_user
  end

  def update_destinations
    @user = current_user
    @user.update(params.require(:user).permit(:destination_ids => []))
    redirect_to root_path
  end

  def edit_dates
    @user = current_user
  end
  
  def update_date
    @user = current_user
  end
end