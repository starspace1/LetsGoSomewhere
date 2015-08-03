json.all_markers @destinations do |destination|
  json.id destination.id
  json.name destination.to_s
  json.latLng [destination.latitude, destination.longitude]
end

json.selected_markers do
  json.array! @selected_destination_ids
end