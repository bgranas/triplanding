class AddPhotoUrlToDestinations < ActiveRecord::Migration
  def up
  	add_column :destinations, :photoURL, :string
  end

  def down
  	remove_column :destinations, :photoURL
  end

end
