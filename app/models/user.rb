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
    busy_intervals.create(start_time: DateTime.iso8601(date), end_time: DateTime.iso8601(date)) unless busy_on? date
  end

  def mark_as_free date
    busy_intervals.where("start_time = ? and end_time = ?", DateTime.iso8601(date), DateTime.iso8601(date)).destroy_all
  end

  def busy_on? date
    busy_intervals.where("start_time = ? or end_time = ?", DateTime.iso8601(date), DateTime.iso8601(date)).any?
  end
end
