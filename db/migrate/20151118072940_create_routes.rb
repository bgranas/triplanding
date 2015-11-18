class CreateRoutes < ActiveRecord::Migration
  def up
    create_table :routes do |t|

      t.timestamps null: false
    end
  end

  def down
  	drop_table :routes
  end
end
