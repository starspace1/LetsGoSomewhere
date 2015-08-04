json.array!(@busy_intervals) do |interval|
  json.extract! interval, :id
  json.title "Busy"
  json.start interval.start_date
  json.end interval.end_date + 1
  json.allDay "true"
  json.rendering "background"
  json.color "red"
  json.backgroundColor "red"
end