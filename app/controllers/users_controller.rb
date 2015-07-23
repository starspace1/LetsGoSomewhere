class UsersController < ApplicationController
  def new_destination
    @user = User.find(params[:id])  
  end

  def create_destination
    @user = User.find(params[:id]) 
    @user.update(params.require(:user).permit(:destination_ids => []))
    redirect_to root_path
  end
end