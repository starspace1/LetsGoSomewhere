class BusyInterval < ActiveRecord::Base
  validates_presence_of :start_time, :end_time
  belongs_to :user

  def adjacent_to? date
    start_time == date + 1 || end_time == date - 1
  end

  def extend_interval date
    if start_time == date + 1
      update_attribute(:start_time, date)
    elsif end_time == date - 1
     update_attribute(:end_time, date)
    end
  end
end
