class AddConsensusStructureToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :consensus_structure, :text
  end
end
