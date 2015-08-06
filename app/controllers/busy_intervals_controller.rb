class BusyIntervalsController < ApplicationController
  def index
    # TODO jump to date of earliest trip
    @busy_intervals = current_user.busy_intervals
  end

  def create
    @date = DateTime.iso8601(params[:date])
    # TODO don't even add this interval if already contained in current_user.busy_intervals
    @busy_interval = current_user.busy_intervals.create(start_date: @date, end_date: @date)
    current_user.busy_intervals.merge_intervals!
  end

  def edit
    @user = current_user
  end

  def destroy
    @id = params[:id]
    @can_remove = current_user.busy_intervals.exists?(@id)
    current_user.busy_intervals.find(@id).destroy if @can_remove
  end

  def import
    gcal = GoogleCalendar.new
    gcal.set_access_token(session[:access_token])
    @busy_dates = gcal.busy_dates(current_user.earliest_trip_date, current_user.latest_trip_date)
    @busy_dates.each do |date|
      current_user.busy_intervals.create(start_date: date['start'], end_date: date['end'])
    end
    current_user.busy_intervals.merge_intervals!
    redirect_to busy_intervals_path, notice: "Success! We imported your Google Calendar!" 
  end

  def destroy_all
    current_user.busy_intervals.destroy_all
    redirect_to busy_intervals_path, notice: "Calendar was cleared."
  end
end