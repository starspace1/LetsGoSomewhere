class OauthController < ApplicationController

  def authorize
    gcal = GoogleCalendar.new
    redirect_to gcal.authorization_uri.to_s
  end

  def request_access_token
    gcal = GoogleCalendar.new
    session[:access_token] = gcal.get_token(params[:code])
    redirect_to busy_intervals_import_path
  end
end
