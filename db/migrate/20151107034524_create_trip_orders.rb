class CreateTripOrders < ActiveRecord::Migration
  def up
    create_table :trip_orders do |t|
      t.references :trip, index: true, foreign_key: true
      t.references :destination, index: true, foreign_key: true
      t.integer :order_authority

      t.timestamps null: false
    end
  end

  def down
    drop_table :trip_orders
  end
end
