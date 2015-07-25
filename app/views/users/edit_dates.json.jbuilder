json.array!(@user.busy_intervals) do |interval|
  json.extract! interval, :id
  json.title "Busy"
  json.start interval.start_time
  json.end interval.end_time
  json.allDay "true"
  json.rendering "background"
  json.color "red"
  json.backgroundColor "red"
end