class StaticController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @hide_navbar = true
  end
end
