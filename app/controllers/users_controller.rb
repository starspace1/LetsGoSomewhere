class UsersController < ApplicationController
  def new_destination
    @user = User.find(params[:id])  
  end

  def create_destination
    @user = User.find(params[:id]) 
    params[:user][:destination_ids].each do |d|
      # TODO clean up and ensure destination isn't added if it is already there
      @user.destinations << Destination.find(d.to_i) unless d == ""
    end
    redirect_to root_path
  end
end