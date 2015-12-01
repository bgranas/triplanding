class AddDepartureReturnCityToTrips < ActiveRecord::Migration
  def up
    add_column :trips, :departure_city_destination_id, :integer, index: true, foreign_key: true
    add_column :trips, :return_city_destination_id, :integer, index: true, foreign_key: true
  end

  def down
    remove_column :trips, :departure_city_destination_id
    remove_column :trips, :return_city_destination_id
  end
end
