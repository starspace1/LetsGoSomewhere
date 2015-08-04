class BusyInterval < ActiveRecord::Base
  validates_presence_of :start_date, :end_date
  belongs_to :user

  def to_s
    "#{start_date} to #{end_date}"
  end

  def self.merged_intervals
    sorted_intervals = self.order(:start_date).to_a
    merged_intervals = []
    merged_intervals.unshift(sorted_intervals.shift)
    sorted_intervals.each do |interval|
      # Get the interval with the earliest start time
      top = merged_intervals.first()
      if top.end_date < interval.start_date - 1
        # This interval isn't overlapping with top
        # Add to merged intervals
        merged_intervals.unshift(interval)
      elsif top.end_date < interval.end_date
        # This interval is overlapping with top
        # Update the end_date of top 
        top.end_date = interval.end_date
        merged_intervals.shift
        merged_intervals.unshift(top)
      end
    end
    # Return the array of merged intervals 
    # Reverse it so it's sorted by start date
    merged_intervals.reverse!
  end
end
