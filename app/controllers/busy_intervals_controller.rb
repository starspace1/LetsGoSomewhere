class BusyIntervalsController < ApplicationController

  def index
    @busy_intervals = current_user.busy_intervals
  end

  def edit
    @user = current_user
  end
  
  def create
    @date = DateTime.iso8601(params[:date])
    @busy_interval = current_user.mark_as_busy(@date)
  end

  def destroy
    @id = params[:id]
    @can_remove = current_user.busy_intervals.exists?(@id)
    current_user.busy_intervals.find(@id).destroy if @can_remove
  end
end