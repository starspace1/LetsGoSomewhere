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
  
  def add_date
    @date = DateTime.iso8601(params[:date])
    @busy_interval = current_user.mark_as_busy(@date)
  end

  def remove_date
    @id = params[:id]
    @can_remove = current_user.busy_intervals.exists?(@id)
    current_user.busy_intervals.find(@id).destroy if @can_remove
  end
end