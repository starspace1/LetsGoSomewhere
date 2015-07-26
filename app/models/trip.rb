class Trip < ActiveRecord::Base
  validates :name, presence: true
  has_many :groups
  has_many :users, through: :groups

  def destination_ids
    # TODO make less C++ish
    user_dests = []
    users.each do |user|
      user_dests << user.destination_ids
    end
    user_dests.inject { |result, element| result & element }
  end

end
