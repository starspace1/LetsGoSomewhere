class InterestsController < ApplicationController
  def edit
    @user = current_user
    @destinations = Destination.all
    # For some reason the selected marker ids are shifted by 1 in jvectormap
    @selected_destination_ids = @user.destination_ids.map { |i| i - 1 }
  end

  def update
    @user = current_user
    @user.update(params.require(:user).permit(:destination_ids => []))
    redirect_to root_path, notice: "Success! Updated your destinations."
  end

  def add
    new_destination = Destination.find(params[:id])
    # TODO remove interest if it's already user's destination list
    current_user.destinations << new_destination
    # TODO flash now new_destination added
    render :map
  end

  def map
  end
end
