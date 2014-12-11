require "rbfam"

entries = Bio::Stockholm::Reader.parse_from_file("rfam_12.seed.utf8") and nil

Rbfam.connect(config: { adapter: "mysql2", database: "rbfam", username: "root", password: "" })

class Family < ActiveRecord::Base; has_one :alignment; end
class Alignment < ActiveRecord::Base; belongs_to :family; end
class Sequence < ActiveRecord::Base; belongs_to :alignment; end

Parallel.each(entries, progress: "Populating MySQL") do |stockholm|
  family = Family.find_or_create_by(name: stockholm.gf_features["AC"], description: stockholm.gf_features["DE"])
  
  alignment = Alignment.find_or_create_by(family: family) do |alignment|
    alignment.stockholm           = stockholm.to_yaml
    alignment.consensus_structure = stockholm.gc_features["SS_cons"].gsub(?<, ?().gsub(?>, ?))
  end
  
  stockholm.records.reject { |key, _| key == ?# }.each do |identifier, record|
    accession, from, to = identifier.split(/[\/-]/)
    
    Sequence.find_or_create_by(alignment: alignment, accession: accession, from: from, to: to) do |sequence|
      raw_sequence                = record.sequence.upcase
      sequence.stripped_sequence  = raw_sequence.gsub(/[^AUGC]/, "")
      sequence.alignment_sequence = raw_sequence
    end
  end
end and nil
