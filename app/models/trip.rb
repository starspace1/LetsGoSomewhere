class Trip < ActiveRecord::Base
  validates :name, presence: true
  has_many :groups
  has_many :users, through: :groups

  # TODO add validation, start_date < end_date etc
  # TODO delete trip if there are no users left in it

  def destination_ids
    # TODO make less C++ish
    user_dests = []
    users.each do |user|
      user_dests << user.destination_ids
    end
    user_dests.inject { |result, element| result & element }
  end

  def free_dates
    # Merge all busy intervals for all users on this trip
    # TODO there's probably a better query
    busy_interval_array =  BusyInterval.where(user_id: user_ids).to_a
    # For each busy interval, create a set from the range
    busy_set_array = busy_interval_array.map do |interval|
      Range.new(interval.start_date, interval.end_date).to_set
    end
    # Combine all the sets together to get all busy dates for all users on trip
    busy_set = busy_set_array.inject { |result, element| result | element }
    test_set = Range.new(start_date, end_date).to_set
    busy_set ||= Set.new
    (test_set - busy_set).to_a
  end
end
