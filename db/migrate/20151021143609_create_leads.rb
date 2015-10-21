class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.string "email", :null => false
      t.timestamps null: false
    end
  end
end
