# TODO this still needs lots of refactoring
class GoogleCalendar
  def initialize
    @client = Google::APIClient.new({
      application_name: GOOGLE[:application_name],
      application_version: '1.0.0'
      })

    @client.authorization = Signet::OAuth2::Client.new({
      client_id: GOOGLE[:client_id],
      client_secret: GOOGLE[:client_secret],
      authorization_uri: GOOGLE[:authorize_uri],
      scope: 'https://www.googleapis.com/auth/calendar.readonly',
      redirect_uri: GOOGLE[:redirect_uri]
      })
  end

  def authorization_uri
    @client.authorization.authorization_uri
  end

  def get_token code
    @client.authorization = Signet::OAuth2::Client.new({
      client_id: GOOGLE[:client_id],
      client_secret: GOOGLE[:client_secret],
      token_credential_uri: GOOGLE[:token_uri],
      redirect_uri: GOOGLE[:redirect_uri],
      code: code
      })
    response = @client.authorization.fetch_access_token!
    response['access_token']
  end

  def set_access_token token
    @client.authorization = Signet::OAuth2::Client.new({
      client_id: GOOGLE[:client_id],
      client_secret: GOOGLE[:client_secret],
      access_token: token
      })
  end

  def cal_api
   @client.discovered_api('calendar', 'v3')
  end

  def primary_calendar_id
    result = @client.execute(:api_method => cal_api.calendars.get,
                        :parameters => {'calendarId' => 'primary'})
    result.data.id
  end

  def busy_dates(start_date, end_date)
    return date_query(start_date, end_date) if end_date <= start_date + 3.months
    return_array = []
    t_min = start_date
    t_max = t_min + 3.months
    while t_max < end_date
      return_array += date_query(t_min, t_max)
      t_min = t_max + 1.day
      t_max = t_min + 3.months
    end
    return_array += date_query(t_min, end_date)
  end

  def date_query(t1, t2)
    response = @client.execute(
      api_method: cal_api.freebusy.query,
      body: JSON.dump({
        timeMin: t1.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
        timeMax: t2.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
        timeZone: "EST",
        items: [{id: primary_calendar_id}]
        }),
      headers: {'Content-Type' => 'application/json'})
    response.data["calendars"][primary_calendar_id]["busy"]
  end
end