class AddFamilyTable < ActiveRecord::Migration
  def up
    create_table :families do |table|
      table.timestamps null: false
      table.string :name
      table.string :description
    end
    
    add_index :families, :name, unique: true
  end

  def down
    drop_table :families
  end
end
