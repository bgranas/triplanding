class AddFieldstoMakeUserReal < ActiveRecord::Migration
  def change
    add_column :users, :hometown, :string, default: ""
    add_column :users, :country_iso_3, :string, :length => 3
    add_column :users, :country, :string
    add_column :users, :blog_url, :string
    add_column :users, :profile_picture_path, :string
    add_column :users, :profile_url, :string
  end
end
