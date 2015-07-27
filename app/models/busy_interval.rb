class BusyInterval < ActiveRecord::Base
  validates_presence_of :start_time, :end_time
  belongs_to :user

  def contains? date
    start_time.to_datetime < date + 1 && date < end_time.to_datetime
  end

  def adjacent_to? date
    start_time.to_datetime == date + 1 || end_time.to_datetime == date
  end

  def extend_interval date
    if start_time.to_datetime == date + 1
      # date is before interval, push back start_time
      update_attribute(:start_time, date)
    elsif end_time.to_datetime == date
      # date is after interval, push forward end_time
     update_attribute(:end_time, date + 1)
    end
  end

  def to_s
    "#{start_time} to #{end_time}"
  end

  def self.merged_intervals
    sorted_intervals = self.order(:start_time).to_a
    merged_intervals = []
    merged_intervals.unshift(sorted_intervals.shift)
    sorted_intervals.each do |interval|
      # Get the interval with the earliest start time
      top = merged_intervals.first()
      if top.end_time < interval.start_time
        # This interval isn't overlapping with top
        # Add to merged intervals
        merged_intervals.unshift(interval)
      elsif top.end_time < interval.end_time
        # This interval is overlapping with top
        # Update the end_time of top 
        top.end_time = interval.end_time
        merged_intervals.shift
        merged_intervals.unshift(top)
      end
    end
    puts merged_intervals.reverse
    # Return the array of merged intervals 
    # Reverse it so it's sorted by start date
    merged_intervals.reverse!
  end
end
