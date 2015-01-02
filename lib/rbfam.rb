require "active_record"
require "active_support/inflector"
require "bio"
require "bio-stockholm"
require "mysql2"
require "parallel"
require "rake"
require "ruby-progressbar"
require "singleton"
require "virtus"

require "rbfam/db_config"
require "rbfam/family"
require "rbfam/rna"

module Rbfam
  def self.db
    DbConfig.instance
  end
end
