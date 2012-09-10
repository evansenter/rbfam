module Rbfam
  class Sequence
    attr_reader :family, :accession, :from, :to, :coord_options

    def initialize(family, accession, from, to, options = {})
      @family        = family
      @accession     = accession
      @from          = from
      @to            = to
      @coord_options = options[:autoload].is_a?(Hash) ? options[:autoload] : {}
      
      if options[:sequence]
        @raw_sequence = (options[:sequence].is_a?(String) ? Bio::Sequence::NA.new(options[:sequence]) : options[:sequence]).upcase
      end
      
      if options[:autoload]
        sequence
      end
    end
    
    def save!(options = {})
      unless extended?
        Rbfam.script("sequences_in_mysql")
      
        SequenceTable.create({ 
          family:          family.family_name, 
          accession:       accession, 
          sequence:        sequence, 
          sequence_length: sequence.length, 
          from:            from, 
          to:              to, 
          seq_from:        seq_from, 
          seq_to:          seq_to,
          seed:            options[:seed]
        })
      else
        tap { puts "ERROR: at this time you can not save #{self.class.name}#extend! objects to protect against DB redundancy (and I'm lazy)." }
      end
    end
    
    def up_coord
      [from, to].min
    end

    def down_coord
      [from, to].max
    end
    
    def seq_from
      up_coord + coord_window.min
    end
    
    def seq_to
      up_coord + coord_window.max
    end
    
    def strand
      plus_strand? ? :plus : :minus
    end

    def plus_strand?
      to > from
    end

    def minus_strand?
      !plus_strand?
    end

    def sequence
      @raw_sequence ||= Rbfam::Utils.rna_sequence_from_entrez(accession, up_coord, coord_window)
      @raw_sequence   = minus_strand? ? @raw_sequence.complement : @raw_sequence
    end
    
    alias :seq :sequence
    
    def mfe_structure
      @mfe_structure ||= ViennaRna::Fold.run(seq).structure
    end
    
    def description
      ("%s %s %s" % [accession, from, to]).gsub(/\W+/, "_")
    end
    
    def fftbor
      @fftbor ||= ViennaRna::Fftbor.run(seq: seq, str: mfe_structure)
    end
    
    def extend!(coord_options = {})
      tap do
        @extended      = true
        @coord_options = coord_options
        remove_instance_variable(:@raw_sequence)
        sequence
      end
    end
    
    def extended?
      @extended
    end
    
    def coord_window
      # Options from coord_options ex: { length: 300, extend: 3 }, or { length: 250, extend: :both }
      range = 0..(down_coord - up_coord)
      
      if coord_options[:length] && coord_options[:direction]
        if coord_options[:direction] == :both
          Range.new(range.min - coord_options[:length], range.max + coord_options[:length])
        else
          case [coord_options[:direction], strand]
          when [3, :plus], [5, :minus] then Range.new(range.min, range.max + coord_options[:length])
          when [5, :plus], [3, :minus] then Range.new(range.min - coord_options[:length], range.max)
          else puts "WARNING: value for :direction key in sequence retreival needs to be one of 5, 3, :both - found (%s)" % coord_options[:direction].inspect
          end
        end
      else
        range
      end
    end
    
    def inspect
      "#<Rbfam::Sequence #{description} #{seq[0, 20] + ('...' if seq.length > 20)}>"
    end
  end
end