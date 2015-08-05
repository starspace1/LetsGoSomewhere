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
    render :edit
  end

  def toggle
    new_destination = Destination.find(params[:id])
    if current_user.interested_in? new_destination.id
      # Remove interest if it's already user's destination list
      current_user.destinations.delete(new_destination)
    else
      # Otherwise, add it
      current_user.destinations << new_destination
    end
    render :edit
  end

  def map
  end

  def list
  end
end
