require "rbfam"
require "activerecord-import/base"

puts "Parsing %s to load in DB." % Rbfam.db.rfam_file
entries = Bio::Stockholm::Reader.parse_from_file(Rbfam.db.rfam_file) and nil
puts "Loading up %d RFam families." % entries.size

Parallel.each(entries, progress: "Populating MySQL") do |stockholm|
  family = Rbfam::Family.find_or_create_by(name: stockholm.gf_features["AC"], description: stockholm.gf_features["DE"], consensus_structure: stockholm.gc_features["SS_cons"])
    
  existing_sequences = family.rnas.map { |sequence| sequence.instance_eval { "%s/%d-%d" % [accession, from, to] } }.to_set
  sequences          = stockholm.records.reject { |key, _| key == ?# || existing_sequences.include?(key) }.map do |identifier, record|
    accession, from, to = identifier.split(/[\/-]/)

    Rbfam::Rna.find_or_initialize_by(family: family, accession: accession, from: from, to: to) do |sequence|
      sequence.gapped_sequence = record.sequence.upcase
      sequence.sequence        = sequence.gapped_sequence.gsub(/[^AUGC]/, "")
    end
  end
  
  Rbfam::Rna.import(sequences.select(&:new_record?))
end and nil
