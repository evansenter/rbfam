module Rbfam
  class Rna < ActiveRecord::Base
    belongs_to :family

    validates :accession, :from, :to, :sequence, :gapped_sequence, presence: true
    validates :from, :to, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :accession, uniqueness: { scope: [:sequence, :from, :to] }
    
    scope :plus_strand,  ->{ where(arel_table[:to].gt(arel_table[:from])) }
    scope :minus_strand, ->{ where(arel_table[:to].lt(arel_table[:from])) }
    
    def strand
      plus_strand? ? :plus : :minus
    end

    def plus_strand?
      to > from
    end

    def minus_strand?
      !plus_strand?
    end
    
    def seq_from
      [from, to].min
    end

    def seq_to
      [from, to].max
    end

    alias_method :seq, def sequence
     as_bioseq(read_attribute(:sequence))
    end
    
    def gapped_sequence
     as_bioseq(read_attribute(:gapped_sequence))
    end
    
    def description
      "%s/%s-%s" % [accession, from, to]
    end
    
    def _id
      description.gsub(/\W+/, "_")
    end
    
    private
    
    def as_bioseq(string)
      Bio::Sequence::NA.new(string)
    end
  end
end
