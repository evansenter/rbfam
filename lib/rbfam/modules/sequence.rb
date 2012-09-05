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
    
    def coord_window
      # Options from @coord_options ex: { length: 300, extend: 3 }
      
      range = 0..(down_coord - up_coord)
      
      if @coord_options[:length] && @coord_options[:extend]
        if range.count < @coord_options[:length]
          length_difference = @coord_options[:length] - range.count
          
          case [@coord_options[:extend], strand]
          when [3, :plus], [5, :minus] then Range.new(range.min, range.max + length_difference)
          when [5, :plus], [3, :minus] then Range.new(range.min - length_difference, range.max)
          else puts "WARNING: value for :extend key in sequence retreival needs to be one of 5, 3 - found (%s)" % @coord_options[:extend]
          end
        else
          puts "WARNING: %s %d-%d (%s) is length %d, but only %d nt. have been requested. Providing the full sequence anyways." % [
            accession,
            from,
            to,
            strand,
            range.count,
            @coord_options[:length]
          ]
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