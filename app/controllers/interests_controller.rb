class InterestsController < ApplicationController
  def edit
    @user = current_user
    @destinations = Destination.all
  end

  def update
    @user = current_user
    @user.update(params.require(:user).permit(:destination_ids => []))
    redirect_to root_path, notice: "Success! Updated your destinations."
  end

  def add
    new_destination = Destination.find(params[:id])
    current_user.destinations << new_destination
    # TODO flash now new_destination added
    render :map
  end

  def map
  end
end
