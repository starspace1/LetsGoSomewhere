class OauthController < ApplicationController

  def authorize
    google_api_client = Google::APIClient.new({
      application_name: GOOGLE[:application_name],
      application_version: '1.0.0'
      })

    google_api_client.authorization = Signet::OAuth2::Client.new({
      client_id: GOOGLE[:client_id],
      client_secret: GOOGLE[:client_secret],
      authorization_uri: GOOGLE[:authorize_uri],
      scope: 'https://www.googleapis.com/auth/calendar.readonly',
      redirect_uri: GOOGLE[:redirect_uri]
      })

    authorization_uri = google_api_client.authorization.authorization_uri

    redirect_to authorization_uri.to_s
  end

  def request_access_token
    google_api_client = Google::APIClient.new({
      application_name: GOOGLE[:application_name],
      application_version: '1.0.0'
      })

    google_api_client.authorization = Signet::OAuth2::Client.new({
      client_id: GOOGLE[:client_id],
      client_secret: GOOGLE[:client_secret],
      token_credential_uri: GOOGLE[:token_uri],
      redirect_uri: GOOGLE[:redirect_uri],
      code: params[:code]
      })

    response = google_api_client.authorization.fetch_access_token!

    session[:access_token] = response['access_token']

    redirect_to oauth_cal_test_path, notice: "Yay! Your access token is #{session[:access_token]}."
  end

  def cal_test
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

    t1 = '2015-07-01T00:00:00.000Z'
    t2 = '2015-08-31T00:00:00.000Z'

    @response = google_api_client.execute(
      api_method: google_calendar_api.freebusy.query,
      body: JSON.dump({
        timeMin: t1,
        timeMax: t2,
        timeZone: "ETC",
        items: [{id: 'leslie.k.brown@gmail.com'}]
        }),
      headers: {'Content-Type' => 'application/json'})

    @items = @response.data["calendars"]["leslie.k.brown@gmail.com"]["busy"] 
  end
end
