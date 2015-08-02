class Destination < ActiveRecord::Base
  validates_presence_of :country, :region
  has_many :interests
  has_many :users, through: :interests

  def to_s
    "#{city}, #{country}"
  end

  def self.regions
    Destination.all.pluck(:region).uniq
  end
end
