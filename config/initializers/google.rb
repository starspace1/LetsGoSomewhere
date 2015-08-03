GOOGLE = { 
  client_id: ENV["GOOGLE_CLIENT_ID"],
  client_secret: ENV["GOOGLE_CLIENT_SECRET"],
  authorize_uri: "https://accounts.google.com/o/oauth2/auth",
  redirect_uri: ENV["GOOGLE_REDIRECT_URI"],
  token_uri: "https://accounts.google.com/o/oauth2/token",
  application_name: "letsgosomewhere"
}