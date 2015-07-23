class CreateDestinations < ActiveRecord::Migration
  def change
    create_table :destinations do |t|
      t.string :city
      t.string :state
      t.string :country
      t.string :region

      t.timestamps null: false
    end
  end
end
