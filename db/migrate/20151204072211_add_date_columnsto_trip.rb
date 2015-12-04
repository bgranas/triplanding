class AddDateColumnstoTrip < ActiveRecord::Migration
  def up
    add_column :trips, :days, :integer
  end

  def down
    remove_column :trips, :days
  end
end
