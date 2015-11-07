class CreateDestinationOrders < ActiveRecord::Migration
  def up
    create_table :destination_orders do |t|
      t.references :trip, index: true, foreign_key: true
      t.references :destination, index: true, foreign_key: true
      t.integer :order_authority

      t.timestamps null: false
    end
  end

  def down
    drop_table :destination_orders
  end
end
