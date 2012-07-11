require "bio"
require "vienna_rna"
require "httparty"
require "active_support/inflector"

module Rbfam
  Dir[File.join(File.dirname(__FILE__), "/modules/*")].each do |file|
    autoload File.basename(file, ".rb").camelize.to_sym, file
  end
  
  def self.script(name)
    require File.dirname(__FILE__) + "/scripts/#{File.basename(name, '.rb')}.rb"
  end
end