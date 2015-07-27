class CreateBusyIntervals < ActiveRecord::Migration
  def change
    create_table :busy_intervals do |t|
      t.date :start_date
      t.date :end_date
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
