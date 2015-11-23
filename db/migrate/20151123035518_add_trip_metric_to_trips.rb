class AddTripMetricToTrips < ActiveRecord::Migration
  def up
    add_column :trips, :cities, :integer
    add_column :trips, :countries, :integer
    add_column :trips, :distance, :integer
  end

  def down
    remove_column :trips, :cities
    remove_column :trips, :countries
    remove_column :trips, :distance
  end
end
