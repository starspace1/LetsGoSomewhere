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

  def import
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

    result = google_api_client.execute(:api_method => google_calendar_api.calendars.get,
                        :parameters => {'calendarId' => 'primary'})

    primary_calendar_id = result.data.id

    # TODO google api only allows get free/busy for 3 month chunks...deal with this
    @response = google_api_client.execute(
      api_method: google_calendar_api.freebusy.query,
      body: JSON.dump({
        timeMin: google_format(current_user.earliest_trip_date),
        timeMax: google_format(current_user.latest_trip_date),
        items: [{id: primary_calendar_id}]
        }),
      headers: {'Content-Type' => 'application/json'})

    @busy_dates = @response.data["calendars"][primary_calendar_id]["busy"] 

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

  private

  def google_format date_time
    # TODO move this to more logical place
    date_time.strftime("%Y-%m-%dT%H:%M:%S.000Z")
  end

end