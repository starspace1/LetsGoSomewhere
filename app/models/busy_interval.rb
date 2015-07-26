class BusyInterval < ActiveRecord::Base
  validates_presence_of :start_time, :end_time
  belongs_to :user
end
