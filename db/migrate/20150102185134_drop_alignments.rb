class DropAlignments < ActiveRecord::Migration
  def change
    drop_table :alignments
    rename_column :sequences, :alignment_id, :family_id
  end
end
