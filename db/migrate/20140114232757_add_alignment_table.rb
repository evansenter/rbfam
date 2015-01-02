class AddAlignmentTable < ActiveRecord::Migration
  def up
    create_table :alignments do |table|
      table.timestamps null: false
      table.belongs_to :family
      table.text :stockholm, limit: 4294967295
      table.text :consensus_structure
    end
  end

  def down
    drop_table :alignments
  end
end
