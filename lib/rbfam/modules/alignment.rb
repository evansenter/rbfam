module Rbfam
  class Alignment
    LINE_REGEXP = /^([\w\.]+)\/(\d+)\-(\d+)\s+([AUGC\.]+)$/
    
    attr_reader :family, :seed
    
    def initialize(family)
      @family = family
    end
    
    def entries(alignment = :seed)
      @parsed_entries ||= pull_from_server(alignment).split(/\n/).reject do |line| 
        line =~ /^#/
      end.select do |line| 
        line =~ LINE_REGEXP
      end.map(&method(:parse_line)).tap do
        @seed = alignment == :seed
      end
    end
    
    def save_entries!
      entries.each { |sequence| sequence.save!(seed: seed) }
    end
    
    def load_entries!(options = {})
      Rbfam.script("sequences_in_mysql")
      
      @parsed_entries = SequenceTable.where({ family: family.family_name }.merge(options)).map do |entry|
        entry.to_rbfam_sequence(family)
      end
    end
    
    private
    
    def pull_from_server(alignment)
      url = "http://rfam.sanger.ac.uk/family/alignment/download/format?acc=%s&alnType=%s&nseLabels=1&format=pfam&download=0" % [
        family.family_name,
        alignment
      ]
      puts "GET: %s" % url unless @reponse
      
      @response ||= if (party = HTTParty.get(url)).response.code == "200"
        puts "RESPONSE: 200 OK"
        party.parsed_response
      else
        raise RuntimeError.new("HTTParty raised the following error when retrieving family %s: %s %s" % [
          family_name,
          party.response.code,
          party.response.message
        ])
      end
    end
    
    def parse_line(line)
      line_match = line.match(LINE_REGEXP)
      
      Rbfam::Sequence.new(family, line_match[1], line_match[2].to_i, line_match[3].to_i, autoload: true)
    end
  end
end