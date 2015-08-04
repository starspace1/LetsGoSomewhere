class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :groups
  has_many :trips, through: :groups
  has_many :interests
  has_many :destinations, through: :interests
  has_many :busy_intervals

  def interested_in? destination_id
    destination_ids.include? destination_id
  end

  def shares_trip_with? other_user
    !(trip_ids & other_user.trip_ids).empty?
  end

  def earliest_trip_date
    if trips.any?
      trips.pluck(:start_date).min
    else
      Date.today
    end
  end

  def latest_trip_date
    if trips.any?
      trips.pluck(:end_date).max
    else
      Date.today.next_month(3)
    end
  end

  def mark_as_busy date
    # TODO clean up this mess
    # Look through existing busy intervals for this user
    busy_intervals.each do |interval|
      # If this interval contains date, do nothing
      if interval.contains? date
        return false
      end 
      # If interval is adjacent to date, 
      if interval.adjacent_to? date
        # Edit that interval, make this date the new start or end date for the interval
        interval.extend_interval date
        return interval 
      end
      # TODO account for when the user picks a date adjacent to TWO existing busy intervals
    end
    return busy_intervals.create(start_date: date, end_date: date + 1)
  end
  # TODO move json builder stuff into model file
end
