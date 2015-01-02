class RenameTableAndColumnsForSequence < ActiveRecord::Migration
  def change
    rename_table :sequences, :rnas
    rename_column :rnas, :stripped_sequence, :sequence
    rename_column :rnas, :alignment_sequence, :gapped_sequence
  end
end
