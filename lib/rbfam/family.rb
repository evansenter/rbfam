module Rbfam
  class Family < ActiveRecord::Base
    has_many :rnas
    
    validates :name, :description, :consensus_structure, presence: true
    validates :name, uniqueness: true
    
    def self.rf(id)
      int_id = id.to_i
      find_by_name("RF%s%d" % [?0 * (5 - Math.log10(int_id).ceil), int_id])
    end
    
    def self.named(string)
      where(arel_table[:description].matches("%#{string}%"))
    end
  end
end
