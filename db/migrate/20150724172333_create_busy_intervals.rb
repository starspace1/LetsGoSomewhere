class CreateBusyIntervals < ActiveRecord::Migration
  def change
    create_table :busy_intervals do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
