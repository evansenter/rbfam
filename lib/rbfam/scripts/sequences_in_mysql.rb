require "mysql2"
require "active_record"

module Rbfam
  module DB
    class Sequence < ActiveRecord::Base
      belongs_to :alignment

      validates_uniqueness_of :accession, scope: [:stripped_sequence, :from, :to]

      def self.connect
        ActiveRecord::Base.establish_connection(config = { adapter: "mysql2", username: "root", reconnect: true })

        unless ActiveRecord::Base.connection.execute("show databases").to_a.inject(&:+).include?("rbfam")
          ActiveRecord::Base.connection.create_database("rbfam")
        end

        ActiveRecord::Base.establish_connection(config.merge(database: "rbfam"))

        inline_rails if defined?(inline_rails)
      end

      def to_rbfam(family = nil)
        # Should use a singleton pattern here to look up the family.
        ::Rbfam::Sequence.new(family || Rbfam::Family.new(family), accession, from, to, { sequence: stripped_sequence })
      end
    end

    class Alignment < ActiveRecord::Base
      belongs_to :family
      has_many :sequences

      self.table_name = "alignments"
    end

    class Family < ActiveRecord::Base
      has_many :alignments
      has_many :sequences, through: :alignment

      self.table_name = "families"
    end

  end
end

Rbfam::DB::Sequence.connect
