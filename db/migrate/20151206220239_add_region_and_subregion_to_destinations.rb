class AddRegionAndSubregionToDestinations < ActiveRecord::Migration
  def up
  	add_column :destinations, :region, :string
  	add_column :destinations, :sub_region, :string
  end

  def down
  	remove_column :destinations, :region
  	remove_column :destinations, :sub_region
  end
end
