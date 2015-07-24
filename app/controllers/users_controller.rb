class UsersController < ApplicationController
  def edit_destinations
    @user = User.find(params[:id])  
  end

  def update_destinations
    @user = User.find(params[:id]) 
    @user.update(params.require(:user).permit(:destination_ids => []))
    redirect_to root_path
  end

  def edit_dates
    @user = User.find(params[:id]) 
  end

  def update_dates

  end
end