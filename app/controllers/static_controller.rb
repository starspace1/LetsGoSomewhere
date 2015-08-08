class StaticController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if user_signed_in?
      @hide_navbar = false
      redirect_to trips_path
    else
      @hide_navbar = true
    end
    
  end
end
