class RemoveDefaultValuesforUsers < ActiveRecord::Migration
  def up
    change_column :users, :email, :string, :default => nil, :limit=> 50
    change_column :users, :name, :string, :default => nil, :limit=> 20
  end

  def down
    change_column :users, :email, :string, :default => "", :limit=> 50
    change_column :users, :name, :string, :default => "", :limit=> 20
  end
end
