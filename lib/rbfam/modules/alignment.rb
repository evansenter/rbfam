module Rbfam
  class Alignment
    include Rbfam::CommonHelpers
    
    LINE_REGEXP = /^([\w\.]+)\/(\d+)\-(\d+)\s+([AUGC\.]+)$/
    
    attr_reader :family, :seed
    
    def initialize(family)
      @family = family
    end
    
    def entries(options = {})
      options = { alignment: :seed, limit: false }.merge(options)
      
      @parsed_entries ||= pull_from_server(options[:alignment]).split(/\n/).reject do |line| 
        line =~ /^#/
      end.select do |line| 
        line =~ LINE_REGEXP
      end[options[:limit] ? 0...options[:limit] : 0..-1].map(&method(:parse_line)).tap do
        @seed = options[:alignment] == :seed
      end
    end
    
    def save_entries!
      entries.each { |sequence| sequence.save!(seed: seed) }
    end
    
    def load_entries!(options = {})
      options = { extended: false }.merge(options)
      
      @parsed_entries = family.load_entries!(options)
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
        raise RuntimeError.new("HTTParty raised the following error when retrieving alignment %s: %s %s" % [
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