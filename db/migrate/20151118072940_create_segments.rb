class CreateSegments < ActiveRecord::Migration
  def up
    create_table :segments do |t|

    	t.integer :route_id
    	t.references :trip, index: true, foreign_key: true
      t.string :path
      t.decimal :duration
      t.decimal :distance
      t.boolean :is_imperial
      t.decimal :cost
      t.string :currency
      t.decimal :cost_native
      t.string :currency_native
      t.string :kind
      t.string :agency_name
      t.string :agency_url
      t.string :airport_s_code
      t.string :airport_t_code
      t.string :s_name
      t.string :t_name
      t.string :flight_path_lat
      t.string :flight_path_lng
      t.boolean :is_major

      t.timestamps null: false
    end
  end

  def down
  	drop_table :segments
  end
end
