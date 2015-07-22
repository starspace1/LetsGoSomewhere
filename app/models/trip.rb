class Trip < ActiveRecord::Base
  validates :name, presence: true
  has_many :groups
  has_many :users, through: :groups
end
