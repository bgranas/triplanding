class CreateUserTrips < ActiveRecord::Migration
  def up
    create_table :user_trips do |t|
      t.references :user
      t.references :trip
      t.boolean :created_by_user, null: false, default: false
      t.boolean :favorited_by_user, null: false, default: false
      t.timestamps null: false
    end

    add_index :user_trips, ["user_id", "trip_id"]
  end

  def down
    drop_table :user_trips
  end
end
