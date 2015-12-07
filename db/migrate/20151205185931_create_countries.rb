class CreateCountries < ActiveRecord::Migration
  def up
    create_table :countries do |t|

    	t.string :name
      t.string :country_iso_2
    	t.string :region
    	t.string :sub_region

      t.timestamps null: false
    end
  end

  def down
  	drop_table :countries
  end
end
