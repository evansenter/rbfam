require "rbfam"
require "nokogiri"

Rbfam.script("sequences_in_mysql")

doc      = Nokogiri::HTML(File.read("./families_11.0.html"))
rfam_ids = doc.css("table#browseTable tbody tr td[3] a").map(&:content)

rfam_ids[689..-1].each do |id|
  puts id
  Rbfam::Family.new(id).alignment.entries.each do |entry|
    hash = entry.instance_eval do
      { 
        family:          family.family_name, 
        accession:       accession, 
        sequence:        sequence, 
        sequence_length: sequence.length, 
        from:            from, 
        to:              to, 
        seq_from:        seq_from, 
        seq_to:          seq_to,
        seed:            1
      }
    end

    SequenceTable.connection.execute(
      "INSERT INTO sequences (#{hash.keys.map { |i| '`%s`' % i.to_s }.join(', ')}) VALUES (#{hash.values.map(&:inspect).join(', ')})"
    )
  end
  puts
end