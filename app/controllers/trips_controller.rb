class TripsController < ApplicationController
  def index
    @trips = current_user.trips
  end

  def new
    @trip = current_user.trips.new
  end

  def create
    @trip = current_user.trips.create(trip_params)
    redirect_to root_path, notice: "Success! Created new trip #{@trip.name}."
  end

  def show
    @trip = Trip.find(params[:id])
  end

  def create_invite
    @trip = Trip.find(params[:trip_id])
  end

  def send_invite
    @trip = Trip.find(params[:trip_id])
    User.invite!({:email => params[:email]}, current_user)
    redirect_to trip_path(@trip), notice: "Success! Invited #{params[:email]} to trip."
  end

  private 
  
  def trip_params
    params.require(:trip).permit(:name)
  end
end
