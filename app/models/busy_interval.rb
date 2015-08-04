class BusyInterval < ActiveRecord::Base
  validates_presence_of :start_date, :end_date
  belongs_to :user

  def to_s
    "#{start_date} to #{end_date}"
  end

  def contained_in? other_interval
    (start_date >= other_interval.start_date) && (end_date <= other_interval.end_date)
  end

  def self.merge_intervals!
    sorted_intervals = self.order(:start_date).to_a
    merged_intervals = []
    merged_intervals.unshift(sorted_intervals.shift)
    sorted_intervals.each do |interval|
      # Get the interval with the earliest start time
      top = merged_intervals.first()
      # puts "Comparing intervals #{top.id} and #{interval.id}"
      # puts "Top: #{top}"
      # puts "Interval: #{interval}"
      if top.end_date < interval.start_date - 1
        # This interval isn't overlapping with top
        # Add to merged intervals
        # puts "Intervals do not overlap. Keep both."
        merged_intervals.unshift(interval)
      elsif top.end_date < interval.end_date
        # This interval is overlapping with top
        # Update the end_date of top 
        # puts "Intervals overlap. Update interval #{top.id} and remove interval #{interval.id}."
        top.end_date = interval.end_date
        merged_intervals.shift
        merged_intervals.unshift(top)
        BusyInterval.find(top.id).update(end_date: interval.end_date)
        BusyInterval.find(interval.id).destroy
      elsif interval.contained_in?(top)
        # puts "Interval #{interval.id} is completely contained within interval #{top.id}. Remove interval #{interval.id}."
        BusyInterval.find(interval.id).destroy
      end
    end
  end
end
