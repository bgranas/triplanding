class UsersChangeLengthtoLimitOops < ActiveRecord::Migration
  def change
    change_column :users, :name, :string, :null => false, :default => "", :limit=> 20
    change_column :users, :email, :string, :null => false, :default => "", :limit=> 50
    change_column :users, :hometown, :string, :default => "", :limit=> 20
    change_column :users, :country_iso_3, :string, :length => 3
    change_column :users, :country, :string, :limit=> 50
    change_column :users, :blog_url, :string, :limit=> 75
    change_column :users, :profile_picture_path, :string, :limit=> 75
    change_column :users, :profile_url, :string, :limit=> 100
  end

end
