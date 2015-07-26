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
end
