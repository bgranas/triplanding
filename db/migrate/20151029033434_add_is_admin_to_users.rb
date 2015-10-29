class AddIsAdminToUsers < ActiveRecord::Migration
  def up
    add_column :users, :isAdmin, :boolean, null: false, default: false
  end

  def down
    remove_column :users, :isAdmin
  end
end
