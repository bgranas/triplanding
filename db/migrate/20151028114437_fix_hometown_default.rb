class FixHometownDefault < ActiveRecord::Migration
  def change
    change_column :users, :name, :string, :null => false,  :limit=> 20
    change_column :users, :email, :string, :null => false,  :limit=> 50
    change_column :users, :hometown, :string,  :limit=> 20
  end
end
