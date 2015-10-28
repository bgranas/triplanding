class FixDefaults < ActiveRecord::Migration
  def change
    change_column :users, :name, :string, :null => false, :default => nil, :limit=> 20
    change_column :users, :email, :string, :null => false, :default => nil, :limit=> 50
    change_column :users, :hometown, :string, :default => nil, :limit=> 20
  end
end
