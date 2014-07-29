class AddSequenceTable < ActiveRecord::Migration
  def up
    create_table :sequences do |table|
      table.timestamps
      table.belongs_to :alignment
      table.string :accession
      table.text :stripped_sequence
      table.text :alignment_sequence
      table.integer :from
      table.integer :to
    end
  end

  def down
    drop_table :sequences
  end
end
