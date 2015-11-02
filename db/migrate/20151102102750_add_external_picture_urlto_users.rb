class AddExternalPictureUrltoUsers < ActiveRecord::Migration
  def up
    add_column :users, :external_picture_url, :string
  end

  def down
    remove_column :users, :external_picture_url
  end
end
