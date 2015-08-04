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
end
