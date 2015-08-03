json.array!(@destinations) do |destination|
  json.extract! destination, :id
  json.name destination.to_s
  json.latLng [destination.latitude, destination.longitude]
  json.selected @user.interested_in? destination.id
end