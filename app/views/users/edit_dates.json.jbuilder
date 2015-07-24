json.array!(@user.busy_intervals) do |interval|
  json.extract! interval, :id
  json.title "Busy Time"
  json.description "Stuff"
  json.start interval.start_time
  json.end interval.end_time
  json.allDay "true"
end