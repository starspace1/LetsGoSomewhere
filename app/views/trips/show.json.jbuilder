json.array!(@trip.free_dates) do |free_date|
  json.title "Free"
  json.start free_date
  json.allDay "true"
  json.rendering "background"
  json.color "green"
  json.backgroundColor "green"
end