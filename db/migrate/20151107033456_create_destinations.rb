class CreateDestinations < ActiveRecord::Migration
  def up
    create_table :destinations do |t|
      t.string :name, :null => false
      t.string :google_place_id, :unique => true
      t.decimal :lat, :scale => 8, :precision => 11
      t.decimal :lng, :scale => 8, :precision => 11
      t.string :formatted_address
      t.string :street_address
      t.string :route
      t.string :intersection
      t.string :country
      t.string :country_iso_2
      t.string :administrative_area_level_1
      t.string :administrative_area_level_2
      t.string :administrative_area_level_3
      t.string :administrative_area_level_4
      t.string :administrative_area_level_5
      t.string :colloquial_area
      t.string :locality
      t.string :neighborhood
      t.integer :postal_code
      t.string :natural_feature
      t.string :airport
      t.string :park
      t.string :point_of_interest
      t.string :ward

      t.timestamps null: false
    end

    add_index :destinations, :google_place_id
  end

  def down
    drop_table :destinations
  end
end
