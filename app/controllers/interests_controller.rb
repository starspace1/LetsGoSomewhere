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

  def map
  end
end
