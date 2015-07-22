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

  def trip_params
    params.require(:trip).permit(:name)
  end
end
