class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.belongs_to :user, index: true
      t.belongs_to :destination, index: true
      t.timestamps null: false
    end
  end
end
