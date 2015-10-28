class ChangeHometownLimit < ActiveRecord::Migration
  def up
    change_column :users, :hometown, :string, :default => nil, :limit=> 100
  end

  def down
    change_column :users, :hometown, :string, :default => nil, :limit=> 20
  end
end
