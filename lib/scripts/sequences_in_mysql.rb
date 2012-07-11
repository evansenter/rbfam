require "mysql2"
require "active_record"

class Object; def this; self; end; end

class SequenceTable < ActiveRecord::Base
  self.table_name = "sequences"
  
  validates_uniqueness_of :accession, scope: [:seq_from, :seq_to]
  
  def self.connect
    ActiveRecord::Base.establish_connection(config = { adapter: "mysql2", username: "root", reconnect: true })

    unless ActiveRecord::Base.connection.execute("show databases").map { |i| i }.flatten.include?("rbfam")
      ActiveRecord::Base.connection.create_database("rbfam")
    end

    ActiveRecord::Base.establish_connection(config.merge(database: "rbfam"))
    
    inline_rails if defined?(inline_rails)
  end
  
  def to_rbfam_sequence(family = nil)
    Rbfam::Sequence.new(family || Rbfam::Family.new(family), accession, from, to, sequence: sequence)
  end
end

SequenceTable.connect

class BuildSequence < ActiveRecord::Migration
  def self.up
    create_table :sequences do |table|
      table.string  :family
      table.string  :accession
      table.text    :sequence
      table.integer :sequence_length
      table.integer :from
      table.integer :to
      table.integer :seq_from
      table.integer :seq_to
      table.boolean :seed, default: false
      table.timestamps
    end 
  end
end

unless ActiveRecord::Base.connection.execute("show tables").map(&:this).flatten.include?("sequences")
  BuildSequence.up
end