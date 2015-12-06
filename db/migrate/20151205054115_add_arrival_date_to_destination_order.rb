class AddArrivalDateToDestinationOrder < ActiveRecord::Migration
  def up
    add_column :destination_orders, :arrival_date, :datetime
  end

  def down
    remove_column :destination_orders, :arrival_date
  end
end
