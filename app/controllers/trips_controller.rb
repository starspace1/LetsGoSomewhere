class TripsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @trips = @user.trips
  end

  def new
    @user = User.find(params[:user_id])
    @trip = @user.trips.new
  end

  def create
    @user = User.find(params[:user_id])
    @trip = @user.trips.create(trip_params)
    redirect_to root_path, notice: "Success! Created new trip #{@trip.name}."
  end

  def show
    @trip = Trip.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(:name)
  end
end
