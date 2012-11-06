module Rbfam
  class Family
    include Rbfam::CommonHelpers
    
    attr_reader :family_name
    
    class << self
      def purine;       new("RF00167"); end
      def tpp;          new("RF00059"); end
      def secis_1;      new("RF00031"); end
      def trna;         new("RF00005"); end
      def let_7;        new("RF00027"); end
      def snora71;      new("RF00056"); end
      def u7;           new("RF00066"); end
      def rose;         new("RF00435"); end
      def hammerhead_3; new("RF00008"); end
    end
    
    def initialize(family_name)
      @family_name = family_name
    end
    
    def alignment
      Rbfam::Alignment.new(self)
    end
    
    def entries(options = {})
      options = { limit: false }.merge(options)
      
      @parsed_entries ||= pull_from_server.split(/\n/).reject { |line| line =~ /^#/ }[options[:limit] ? 0...options[:limit] : 0..-1].map(&method(:parse_line))
    end
    
    def load_entries!(options = {})
      options = { extended: false, seed: true }.merge(options)
      
      Rbfam.script("sequences_in_mysql")
      
      @parsed_entries = SequenceTable.where({ family: family_name }.merge(options)).map do |entry|
        entry.to_rbfam(self)
      end
    end
    
    def save_entries!
      entries.each(&:save!)
    end
    
    private
    
    def pull_from_server
      # It isn't the greatest design pattern to memoize a block where a branch has unmanaged exception raising, but for my uses that should never
      # happen and needs to blow up hard if it does.
      url = "http://rfam.sanger.ac.uk/family/regions?entry=%s" % family_name
      puts "GET: %s" % url unless @reponse
      
      @reponse ||= if (party = HTTParty.get(url)).response.code == "200"
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
      split_line = line.split(/\t/)
      
      Rbfam::Sequence.new(self, split_line[0], split_line[2].to_i, split_line[3].to_i, autoload: true)
    end
  end
end