class Interest < ActiveRecord::Base
  belongs_to :destination
  belongs_to :user
end
