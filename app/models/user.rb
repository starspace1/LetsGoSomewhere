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

  def mark_as_busy date
    # If any contain this date, do nothing
    return if busy_on? date
    # Look through existing busy intervals for this user
    busy_intervals.each do |interval|
      # If any are adjacent to this date, 
      if interval.adjacent_to? DateTime.iso8601(date)
        # Edit that interval, make this date the new start or end date for the interval
        interval.extend_interval DateTime.iso8601(date)
      end
    end
    busy_intervals.create(start_time: DateTime.iso8601(date), end_time: DateTime.iso8601(date)) unless busy_on? date
  end

  def mark_as_free date
    busy_intervals.where("start_time = ? and end_time = ?", DateTime.iso8601(date), DateTime.iso8601(date)).destroy_all
  end

  def busy_on? date
    busy_intervals.where("start_time = ? or end_time = ?", DateTime.iso8601(date), DateTime.iso8601(date)).any?
  end
end
