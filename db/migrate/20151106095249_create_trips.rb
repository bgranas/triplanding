class CreateTrips < ActiveRecord::Migration
  def up
    create_table :trips do |t|
      t.string :title
      t.string :permalink
      t.timestamp :start_date
      t.timestamp :end_date

      t.timestamps null: false
    end
  end

  def down
    drop_table :trips
  end
end
