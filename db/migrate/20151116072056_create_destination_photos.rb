class CreateDestinationPhotos < ActiveRecord::Migration
  def up
    create_table :destination_photos do |t|
      t.references :destination, index: true, foreign_key: true
      t.string :panoramio_photo_id
      t.integer :height
      t.integer :width
      t.decimal :lat
      t.decimal :lng
      t.string :photo_title
      t.string :photo_url
      t.string :photo_file_url
      t.string :photo_size
      t.string :owner_url
      t.string :owner_name
      t.string :owner_id

      t.timestamps null: false
    end
  end

  def down
    drop_table :destination_photos
  end
end
