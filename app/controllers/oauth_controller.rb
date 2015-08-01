class OauthController < ApplicationController

  def authorize
    # TODO DRY it up
    google_api_client = Google::APIClient.new({
      application_name: GOOGLE[:application_name],
      application_version: '1.0.0'
      })

    # TODO DRY it up
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

    redirect_to busy_intervals_import_path
  end
end
