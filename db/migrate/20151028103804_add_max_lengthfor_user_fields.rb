class AddMaxLengthforUserFields < ActiveRecord::Migration
  def change
    change_column :users, :name, :string, :null => false, :default => "", :length => 20
    change_column :users, :email, :string, :null => false, :default => "", :length => 50
    change_column :users, :hometown, :string, :default => "", :length => 20
    change_column :users, :country_iso_3, :string, :length => 3
    change_column :users, :country, :string, :length => 50
    change_column :users, :blog_url, :string, :length => 75
    change_column :users, :profile_picture_path, :string, :length => 75
    change_column :users, :profile_url, :string, :length => 100
  end
end
