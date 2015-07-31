class BusyIntervalsController < ApplicationController
  def index
    @busy_intervals = current_user.busy_intervals
  end

  def create
    @date = DateTime.iso8601(params[:date])
    @busy_interval = current_user.mark_as_busy(@date)
  end

  def edit
    @user = current_user
  end

  def destroy
    @id = params[:id]
    @can_remove = current_user.busy_intervals.exists?(@id)
    current_user.busy_intervals.find(@id).destroy if @can_remove
  end

  def test
    # TODO DRY up
    google_api_client = Google::APIClient.new({
      application_name: GOOGLE[:application_name],
      application_version: '1.0.0'
      })

    google_api_client.authorization = Signet::OAuth2::Client.new({
      client_id: GOOGLE[:client_id],
      client_secret: GOOGLE[:client_secret],
      access_token: session[:access_token]
      })

    google_calendar_api = google_api_client.discovered_api('calendar', 'v3')

    # TODO google api only allows get free/busy for 3 month chunks
    # deal with this.
    t1 = current_user.trips.pluck(:start_date).min.strftime("%Y-%m-%dT%H:%M:%S.000Z")
    t2 = current_user.trips.pluck(:end_date).max.strftime("%Y-%m-%dT%H:%M:%S.000Z")

    # TODO remove testing hard coded data
    response = google_api_client.execute(
      api_method: google_calendar_api.freebusy.query,
      body: JSON.dump({
        timeMin: t1,
        timeMax: t2,
        timeZone: "ETC",
        items: [{id: 'leslie.k.brown@gmail.com'}]
        }),
      headers: {'Content-Type' => 'application/json'})

    # TODO remove testing hard coded data
    @busy_dates = response.data["calendars"]["leslie.k.brown@gmail.com"]["busy"] 

    # TODO merge busy intervals
    @busy_dates.each do |date|
      current_user.busy_intervals.create(start_date: date['start'], end_date: date['end'])
    end

    redirect_to busy_intervals_path, notice: "Success! We imported your Google Calendar!" 
  end

  def destroy_all
    current_user.busy_intervals.destroy_all
    redirect_to busy_intervals_path, notice: "Calendar was cleared."
  end
end