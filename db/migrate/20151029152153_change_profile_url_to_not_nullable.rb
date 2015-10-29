class ChangeProfileUrlToNotNullable < ActiveRecord::Migration
  def up
    change_column :users, :profile_url, :string, :null => false, :limit=> 100
  end

  def down
    change_column :users, :profile_url, :string, :null => true, :limit=> 100
  end
end
